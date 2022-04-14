/**
 *
 *	VGA-Game module.
 *	Displays the game.
 *
 **/

`timescale 1 ns/ 100 ps
module VGAGame(     
	input clk, 			// 100 MHz System Clock
	input clk25,
	input reset, 		// Reset Signal
	input[11:0] color0, // trim color
	input[11:0] color1, // background color
	output hSync, 		// H Sync Signal
	output vSync, 		// Veritcal Sync Signal
	output[3:0] VGA_R,  // Red Signal Bits
	output[3:0] VGA_G,  // Green Signal Bits
	output[3:0] VGA_B,  // Blue Signal Bits
	input[7:0] buttons, // controller buttons
	output screenEnd,	// high for one cycle when frame ends

    // bkg
    input bkg_en,
    input[31:0] bkg_addr,
    input[7:0] bkg_x,
    input[6:0] bkg_y,

	// sp1
    input sp1_en,
    input[31:0] sp1_addr,
    input[7:0] sp1_x,
    input[6:0] sp1_y
	);
	
	// Lab Memory Files Location
	localparam FILES_PATH = "C:/Users/conno/Documents/Duke/Y3.2/CS350/projects/ECE350-Final-Project/Graphics/MemFiles/";
	//localparam FILES_PATH = "./Graphics/MemFiles/";

	// VGA Timing Generation for a Standard VGA Screen
	localparam 
		VIDEO_WIDTH = 640,  // Standard VGA Width
		VIDEO_HEIGHT = 480; // Standard VGA Height

	wire active;
	wire[9:0] x;
	wire[8:0] y;
	
	wire[7:0] x_adj = x >> 2;
	wire[6:0] y_adj = y >> 2;
	
    wire[31:0] bkg_offset = bkg_addr;
    //assign bkg_offset = bkg_en ? bkg_addr : 32'b0;
	
	
	VGATimingGenerator #(
		.HEIGHT(VIDEO_HEIGHT), // Use the standard VGA Values
		.WIDTH(VIDEO_WIDTH))
	Display( 
		.clk25(clk25),  	   // 25MHz Pixel Clock
		.reset(reset),		   // Reset Signal
		.screenEnd(screenEnd), // High for one cycle when between two frames
		.active(active),	   // High when drawing pixels
		.hSync(hSync),  	   // Set Generated H Signal
		.vSync(vSync),		   // Set Generated V Signal
		.x(x), 				   // X Coordinate (from left)
		.y(y)); 			   // Y Coordinate (from top)	   

	// Image Data to Map Pixel Location to Color Address
	localparam 
		PIXEL_COUNT = (VIDEO_WIDTH >> 2)*(VIDEO_HEIGHT >> 2),    // Number of pixels on the screen
		PIXEL_ADDRESS_WIDTH = $clog2(PIXEL_COUNT) + 4,           // Use built in log2 command
		BITS_PER_COLOR = 12, 	  								 // Nexys A7 uses 12 bits/color
		PALETTE_COLOR_COUNT = 2, 								 // Number of Colors available
		PALETTE_ADDRESS_WIDTH = $clog2(PALETTE_COLOR_COUNT) + 1; // Use built in log2 Command
				

	wire colorData;
		
	// bkg GMEM
	wire[PIXEL_ADDRESS_WIDTH-1:0] imgAddress_bkg;  	
	assign imgAddress_bkg = x_adj + 160*y_adj + bkg_offset[PIXEL_ADDRESS_WIDTH-1:0];
	wire colorAddr_bkg; 							
	GRAM #(		
		.DEPTH(PIXEL_COUNT*4), 
		.DATA_WIDTH(1),      
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     
		.MEMFILE({FILES_PATH, "bkg_boxtest.mem"}))
	GMEM_160by120(
		.clk(clk), 						
		.addr(imgAddress_bkg),			
		.dataOut(colorAddr_bkg),
		.wEn(1'b0)); 						
	
	// sprite GMEM
	wire[7:0] imgAddress_sp1;  	
	assign imgAddress_sp1 = (x_adj - sp1_x) + 16*(y_adj - sp1_y) + sp1_addr[7:0];
	wire colorAddr_sp1; 
	GRAM #(		
		.DEPTH(256), 
		.DATA_WIDTH(1),   
		.ADDRESS_WIDTH(8), 
		.MEMFILE({FILES_PATH, "sp_guy0.mem"}))
	GMEM_16by16(
		.clk(clk), 						 
		.addr(imgAddress_sp1),
		.dataOut(colorAddr_sp1),	
		.wEn(1'b0)); 			
	


	// draw sprite 1
	wire [7:0] sp1_l = sp1_x;		wire [6:0] sp1_t = sp1_y;
	wire [7:0] sp1_r = sp1_x + 16;	wire [6:0] sp1_b = sp1_y + 16;
	reg in_sp1;	
	always @(posedge clk25) begin
		in_sp1	<=	x_adj >= sp1_l &
					x_adj <  sp1_r &
					y_adj >= sp1_t &
					y_adj <  sp1_b;
	end

	
	// color data
	assign colorData = in_sp1 & sp1_en ? colorAddr_sp1 : colorAddr_bkg;
    



	assign {VGA_R, VGA_G, VGA_B} = ~colorData ? color0 : color1;
endmodule