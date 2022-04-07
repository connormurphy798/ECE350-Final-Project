/**
 *
 *	VGA-Controller interaction module.
 *	Displays an interactive image of a Sega Genesis controller on the VGA screen,
 *	with button pushes appearing on the image.
 *	Used to assess whether the controller is properly connected to the system.
 *
 **/

`timescale 1 ns/ 100 ps
module VGATestController(     
	input clk, 			// 100 MHz System Clock
	input reset, 		// Reset Signal
	output hSync, 		// H Sync Signal
	output vSync, 		// Veritcal Sync Signal
	output[3:0] VGA_R,  // Red Signal Bits
	output[3:0] VGA_G,  // Green Signal Bits
	output[3:0] VGA_B,  // Blue Signal Bits
	input[7:0] buttons	// controller buttons
	);
	
	// Lab Memory Files Location
	localparam FILES_PATH = "C:/Users/conno/Documents/Duke/Y3.2/CS350/projects/ECE350-Final-Project/Graphics/MemFiles/";

	// Clock divider 100 MHz -> 25 MHz
	wire clk25; // 25MHz clock

	reg[1:0] pixCounter = 0;      // Pixel counter to divide the clock
    assign clk25 = pixCounter[1]; // Set the clock high whenever the second bit (2) is high
	always @(posedge clk) begin
		pixCounter <= pixCounter + 1; // Since the reg is only 3 bits, it will reset every 8 cycles
	end

	// VGA Timing Generation for a Standard VGA Screen
	localparam 
		VIDEO_WIDTH = 640,  // Standard VGA Width
		VIDEO_HEIGHT = 480; // Standard VGA Height

	wire active, screenEnd;
	wire[9:0] x;
	wire[8:0] y;
	
	wire[7:0] x_adj = x >> 2;
	wire[6:0] y_adj = y >> 2;
	

	
	
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
		PIXEL_ADDRESS_WIDTH = $clog2(PIXEL_COUNT) + 1,           // Use built in log2 command
		BITS_PER_COLOR = 12, 	  								 // Nexys A7 uses 12 bits/color
		PALETTE_COLOR_COUNT = 2, 								 // Number of Colors available
		PALETTE_ADDRESS_WIDTH = $clog2(PALETTE_COLOR_COUNT) + 1; // Use built in log2 Command

	wire[PIXEL_ADDRESS_WIDTH-1:0] imgAddress;  	// Image address for the image data
	assign imgAddress = x_adj + 160*y_adj; 		// Address calculated coordinate
	wire colorAddr; 							// Color address for the color palette

	RAM #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(PALETTE_ADDRESS_WIDTH),      // Set data width according to the color palette
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "bkg_controller.mem"})) 	// Memory initialization
	ImageData(
		.clk(clk), 						 // Falling edge of the 100 MHz clk
		.addr(imgAddress),					 // Image data address
		.dataOut(colorAddr),				 // Color palette address
		.wEn(1'b0)); 						 // We're always reading

	// Color Palette to Map Color Address to 12-Bit Color
	wire[BITS_PER_COLOR-1:0] colorData; // 12-bit color data at current pixel
	

	// Assign to output color from register if active
	wire[BITS_PER_COLOR-1:0] colorOut, color0, color1;		  // Output color
	assign color0 = 12'b001100110011; 	// black
	assign color1 = 12'b111011101110;	// white
	assign colorData = colorAddr ? color1 : color0;
	assign colorOut = active ? colorData : color1; // When not active, output white



	wire button_color;
	assign button_color = color0; // let's try black

		// UP
	wire [7:0] U_l = 41;	wire [6:0] U_t = 55;	wire [7:0] U_r = 46;	wire [6:0] U_b = 62;

		// DOWN
	wire [7:0] D_l = 41;	wire [6:0] D_t = 71;	wire [7:0] D_r = 46;	wire [6:0] D_b = 78;

		// LEFT
	wire [7:0] L_l = 32;	wire [6:0] L_t = 64;	wire [7:0] L_r = 39;	wire [6:0] L_b = 69;

		// RIGHT
	wire [7:0] R_l = 48;	wire [6:0] R_t = 63;	wire [7:0] R_r = 55;	wire [6:0] R_b = 69;

		// A
	wire [7:0] A_l = 107;	wire [6:0] A_t = 69;	wire [7:0] A_r = 112;	wire [6:0] A_b = 74;

		// B
	wire [7:0] B_l = 116;	wire [6:0] B_t = 65;	wire [7:0] B_r = 121;	wire [6:0] B_b = 70;

		// C
	wire [7:0] C_l = 125;	wire [6:0] C_t = 61;	wire [7:0] C_r = 130;	wire [6:0] C_b = 66;

		// START
	wire [7:0] S_l = 99;	wire [6:0] S_t = 55;	wire [7:0] S_r = 110;	wire [6:0] S_b = 57;
 
		// inside a button? just d-pad for now
	reg inUP, inDOWN, inLEFT, inRIGHT, inA, inB, inC, inSTART;
	always @(posedge clk25) begin
	   	inUP	<=	x_adj >= U_l &
					x_adj <  U_r &
					y_adj >= U_t &
					y_adj <  U_b;
		inDOWN 	<=	x_adj >= D_l &
					x_adj <  D_r &
					y_adj >= D_t &
					y_adj <  D_b;
		inLEFT 	<=	x_adj >= L_l &
					x_adj <  L_r &
					y_adj >= L_t &
					y_adj <  L_b;
		inRIGHT <=	x_adj >= R_l &
					x_adj <  R_r &
					y_adj >= R_t &
					y_adj <  R_b;
		inA 	<=	x_adj >= A_l &
					x_adj <  A_r &
					y_adj >= A_t &
					y_adj <  A_b;
		inB 	<=	x_adj >= B_l &
					x_adj <  B_r &
					y_adj >= B_t &
					y_adj <  B_b;
		inC 	<=	x_adj >= C_l &
					x_adj <  C_r &
					y_adj >= C_t &
					y_adj <  C_b;
		inSTART <=	x_adj >= S_l &
					x_adj <  S_r &
					y_adj >= S_t &
					y_adj <  S_b;
	end
	


	// Quickly assign the output colors to their channels using concatenation
	/*
	wire inBUTTON_dpad = inUP | inDOWN | inLEFT | inRIGHT;
	wire inBUTTON_face = inA | inB | inC | inSTART;
	wire inBUTTON = inBUTTON_dpad | inBUTTON_face;
	*/
	wire onUP, onDOWN, onLEFT, onRIGHT, onA, onB, onC, onSTART;
	assign onUP		= buttons[0] & inUP;
	assign onDOWN	= buttons[1] & inDOWN;
	assign onLEFT	= buttons[2] & inLEFT;
	assign onRIGHT	= buttons[3] & inRIGHT;
	assign onA		= buttons[4] & inA;
	assign onB		= buttons[5] & inB;
	assign onC		= buttons[6] & inC;
	assign onSTART	= buttons[7] & inSTART;

	wire onBUTTON_dpad = onUP | onDOWN | onLEFT | onRIGHT;
	wire onBUTTON_face = onA | onB | onC | onSTART;
	wire onBUTTON = onBUTTON_dpad | onBUTTON_face;

	assign {VGA_R, VGA_G, VGA_B} = onBUTTON ? color0 : colorOut;
endmodule