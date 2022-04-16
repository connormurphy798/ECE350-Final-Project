/**
 *
 *  The GuyBox.
 *
 **/

`timescale 1ns / 1ps

module GuyBox (

    input clk,
    input reset,

    // controller pins
    input pin0,
	input pin1,
	input pin2,
	input pin3,
	input pin5,
	output pin6,
	input pin8,
    
    // VGA handling
    output hSync, 		
	output vSync,
	output[3:0] VGA_R,
	output[3:0] VGA_G,
	output[3:0] VGA_B,
	
    // state info
    output[7:0] buttons,
    output[3:0] curr/*,
    
    // testing
    output rtest1,
    output rtest2,
    output RAM_val   // 
    */
    );



    // Clock divider
	wire clk50, clk25, clk125, clk0625, clk03125, clk015625;

	reg[5:0] pixCounter = 0;      // Pixel counter to divide the clock
    assign clk50 = pixCounter[0];
    assign clk25 = pixCounter[1]; // Set the clock high whenever the second bit (2) is high
    assign clk125 = pixCounter[2];
    assign clk0625 = pixCounter[3];
    assign clk03125 = pixCounter[4];
    assign clk015625 = pixCounter[5];
	always @(posedge clk) begin
		pixCounter <= pixCounter + 1; // Since the reg is only 3 bits, it will reset every 8 cycles
	end


    

	wire rwe, mwe;
	wire[4:0] rd, rs1, rs2, rs3;
	wire[31:0] instAddr, instData, 
		rData, regA, regB, regC,
		memAddr, memDataIn;
    wire memDataOut;
	wire quit, reset_rf, QUIT, RESET_RF;

    wire screenEnd;
	dffe_ref dffQUIT(QUIT, quit, clk25, 1'b1, 1'b0);
	dffe_ref dffRSRF(RESET_RF, reset_rf, clk25, 1'b1, 1'b0);


    // Sega Genesis controller interface
    ControllerController sega(buttons, pin0, pin1, pin2, pin3, pin5, pin6, pin8, clk03125);


    // Graphics
    wire [31:0] address_gmem;
    wire [31:0] x_coord;
    wire [31:0] y_coord;
    wire [11:0] sprite;
    wire gmem_en;
	VGAGraphics vga(.clk(clk), .clk25(clk25), .reset(reset | QUIT),
					.hSync(hSync), .vSync(vSync),
					.VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B),
					.curr(curr), .screenEnd(screenEnd), .buttons(buttons),
					.gmem_en(gmem_en), .addr_gmem_IN(address_gmem),
					.x_coord_IN(x_coord[7:0]), .y_coord_IN(y_coord[6:0]),
					.imgcode_IN(sprite[1:0]));
		
		
    // testing
    wire [31:0] M_instr;    
	
	localparam INSTR_FILE = "C:/Users/conno/Documents/Duke/Y3.2/CS350/projects/ECE350-Final-Project/Games/simple-fall";
	localparam DATA_FILE = "C:/Users/conno/Documents/Duke/Y3.2/CS350/projects/ECE350-Final-Project/Graphics/MemFiles/bkg_falltest";
	//localparam INSTR_FILE = "./Games/simple-sprite";

	// Main Processing Unit
	processor CPU(.clock(clk25), .reset(reset | screenEnd | ~curr[3]), 
								
		// ROM
		.address_imem(instAddr), .q_imem(instData),
									
		// Regfile
		.ctrl_writeEnable(rwe),     .ctrl_writeReg(rd),
		.ctrl_readRegA(rs1),     .ctrl_readRegB(rs2),   .ctrl_readRegC(rs3),
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB), .data_readRegC(regC),
									
		// RAM
		.wren(mwe), .address_dmem(memAddr), 
		.data(memDataIn), .q_dmem({31'b0, memDataOut}),
		
		// Controller
		.controller(buttons),
        
        // Graphics
        .address_gmem(address_gmem), .x_coord(x_coord), .y_coord(y_coord), .sprite(sprite), .gmem_en(gmem_en),

		// Quit Game
		.quit(quit), .reset_rf(reset_rf)/*,

        // testing
        .M_instruction(M_instr)*/
    
    ); 
	
	// Instruction Memory (ROM)
	ROM #(.MEMFILE({INSTR_FILE, ".mem"}))
	InstMem(.clk(clk25), 
		.addr(instAddr[11:0]), 
		.dataOut(instData));
	
	// Register File
	regfile RegisterFile(.clock(clk25), 
		.ctrl_writeEnable(rwe), .ctrl_reset(reset | RESET_RF), 
		.ctrl_writeReg(rd),
		.ctrl_readRegA(rs1), .ctrl_readRegB(rs2), .ctrl_readRegC(rs3),
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB), .data_readRegC(regC),
        .data_rtest1(rtest1), .data_rtest2(rtest2));
						
	// Processor Memory (RAM)
	RAM #(		
		.DEPTH(19200), 
		.DATA_WIDTH(1),      
		.ADDRESS_WIDTH(15),     
		.MEMFILE({DATA_FILE, ".mem"})) 
	ProcMem(.clk(clk25), 
		.wEn(mwe), 
		.addr(memAddr[14:0]), 
		.dataIn(memDataIn[0]), 
		.dataOut(memDataOut));
	
    assign RAM_val = memDataOut;

endmodule