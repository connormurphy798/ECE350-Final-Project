/**
 *
 *	VGA-Welcome screen module.
 *  Displays on boot.
 *
 **/

`timescale 1 ns/ 100 ps
module VGAWelcome(     
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
	input [7:0] buttons,// controller buttons (unused)
	output screenEnd	// high for one cycle when frame ends
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
		PALETTE_ADDRESS_WIDTH = 1;

	wire[PIXEL_ADDRESS_WIDTH-1:0] imgAddress;  	// Image address for the image data
	assign imgAddress = x_adj + 160*y_adj; 		// Address calculated coordinate
	wire colorAddr; 							// Color address for the color palette

	GRAM #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(1),      // Set data width according to the color palette
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "bkg_welcome.mem"})) 	// Memory initialization
	ImageData(
		.clk(clk), 						 // Falling edge of the 100 MHz clk
		.addr(imgAddress),					 // Image data address
		.dataOut(colorAddr),				 // Color palette address
		.wEn(1'b0)); 						 // We're always reading

	// Color Palette to Map Color Address to 12-Bit Color
	wire[BITS_PER_COLOR-1:0] colorData; // 12-bit color data at current pixel
	

	// Assign to output color from register if active
	wire[BITS_PER_COLOR-1:0] colorOut;		  // Output color
	assign colorData = colorAddr ? color1 : color0;


	assign {VGA_R, VGA_G, VGA_B} = colorData;
endmodule