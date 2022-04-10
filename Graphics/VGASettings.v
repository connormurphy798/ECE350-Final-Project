/**
 *
 *	VGA-Settings module.
 *	Displays an interactive homescreen on the VGA screen,
 *	with button pushes affecting the position of a "select" box.
 *
 **/

`timescale 1 ns/ 100 ps
module VGASettings(     
	input clk, 			// 100 MHz System Clock
	input reset, 		// Reset Signal
	output hSync, 		// H Sync Signal
	output vSync, 		// Veritcal Sync Signal
	output[3:0] VGA_R,  // Red Signal Bits
	output[3:0] VGA_G,  // Green Signal Bits
	output[3:0] VGA_B,  // Blue Signal Bits
	input[7:0] buttons, // controller buttons
	input fsm_en,		// enable homescreen fsm
	output[1:0] chc		// current state (choice)
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
		.MEMFILE({FILES_PATH, "bkg_colors.mem"})) 	// Memory initialization
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

			// DEFAULT
	wire [7:0] D0_l = 4;	wire [6:0] D0_t = 48;	wire [7:0] D0_r = 75;	wire [6:0] D0_b = 50;
	wire [7:0] D1_l = 72;	wire [6:0] D1_t = 29;	wire [7:0] D1_r = 75;	wire [6:0] D1_b = 32;

		// GAMEBOY
	wire [7:0] G0_l = 85;	wire [6:0] G0_t = 48;	wire [7:0] G0_r = 156;	wire [6:0] G0_b = 50;
	wire [7:0] G1_l = 153;	wire [6:0] G1_t = 29;	wire [7:0] G1_r = 156;	wire [6:0] G1_b = 32;

    	// NIGHTMODE
	wire [7:0] N0_l = 4;	wire [6:0] N0_t = 87;	wire [7:0] N0_r = 75;	wire [6:0] N0_b = 89;	
	wire [7:0] N1_l = 72;	wire [6:0] N1_t = 68;	wire [7:0] N1_r = 75;	wire [6:0] N1_b = 71;

		// BLUE
	wire [7:0] B0_l = 85;	wire [6:0] B0_t = 87;	wire [7:0] B0_r = 156;	wire [6:0] B0_b = 89;
	wire [7:0] B1_l = 153;	wire [6:0] B1_t = 68;	wire [7:0] B1_r = 156;	wire [6:0] B1_b = 71;
 
		// inside a selection? 0 denotes mouseover, 1 denotes choice
	reg inDFLT0, inDFLT1;
	reg inGBOY0, inGBOY1;
	reg inNGHT0, inNGHT1;
	reg inBLUE0, inBLUE1;
	always @(posedge clk25) begin
	   	inDFLT0	<=	x_adj >= D0_l &
					x_adj <  D0_r &
					y_adj >= D0_t &
					y_adj <  D0_b;
		inDFLT1	<=	x_adj >= D1_l &
					x_adj <  D1_r &
					y_adj >= D1_t &
					y_adj <  D1_b;
		
		inGBOY0	<=	x_adj >= G0_l &
					x_adj <  G0_r &
					y_adj >= G0_t &
					y_adj <  G0_b;
		inGBOY1	<=	x_adj >= G1_l &
					x_adj <  G1_r &
					y_adj >= G1_t &
					y_adj <  G1_b;

		inNGHT0	<=	x_adj >= N0_l &
					x_adj <  N0_r &
					y_adj >= N0_t &
					y_adj <  N0_b;
		inNGHT1	<=	x_adj >= N1_l &
					x_adj <  N1_r &
					y_adj >= N1_t &
					y_adj <  N1_b;
		
		inBLUE0	<=	x_adj >= B0_l &
					x_adj <  B0_r &
					y_adj >= B0_t &
					y_adj <  B0_b;
		inBLUE1	<=	x_adj >= B1_l &
					x_adj <  B1_r &
					y_adj >= B1_t &
					y_adj <  B1_b;
	end
	


	// Quickly assign the output colors to their channels using concatenation
	wire [1:0] sel;
    ColorsFSM fsm(sel, chc, buttons, clk, fsm_en, reset);
	
	wire onDFLT0, onDFLT1;
	assign onDFLT0	= inDFLT0 & (~sel[1] & ~sel[0]);  // state 00 = DEFAULT
	assign onDFLT1	= inDFLT1 & (~chc[1] & ~chc[0]);

	wire onGBOY0, onGBOY1;
	assign onGBOY0	= inGBOY0 & (~sel[1] &  sel[0]);  // state 01 = GAMEBOY
	assign onGBOY1	= inGBOY1 & (~chc[1] &  chc[0]);

	wire onNGHT0, onNGHT1;
	assign onNGHT0	= inNGHT0 & ( sel[1] &  ~sel[0]);  // state 10 = NIGHTMODE
	assign onNGHT1	= inNGHT1 & ( chc[1] &  ~chc[0]);

	wire onBLUE0, onBLUE1;
	assign onBLUE0	= inBLUE0 & ( sel[1] &  sel[0]);  // state 11 = BLUE
	assign onBLUE1	= inBLUE1 & ( chc[1] &  chc[0]);

	
	wire onSELECTION 	= onDFLT0 | onGBOY0 | onNGHT0 | onBLUE0;
	wire onCHOICE 		= onDFLT1 | onGBOY1 | onNGHT1 | onBLUE1;

	assign {VGA_R, VGA_G, VGA_B} = onSELECTION | onCHOICE ? color0 : colorOut;
endmodule