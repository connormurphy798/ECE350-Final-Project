/**
 *
 *	VGA-Controller interaction test module.
 *	Displays an interactive image of a Sega Genesis controller on the VGA screen,
 *	with button pushes appearing on the image.
 *	Used to assess whether the controller is properly connected to the system.
 *
 **/

`timescale 1 ns/ 100 ps
module VGAHomescreenTest(     
	input clk, 			// 100 MHz System Clock
	input reset, 		// Reset Signal
	output hSync, 		// H Sync Signal
	output vSync, 		// Veritcal Sync Signal
	output[3:0] VGA_R,  // Red Signal Bits
	output[3:0] VGA_G,  // Green Signal Bits
	output[3:0] VGA_B,  // Blue Signal Bits
	inout ps2_clk,
	inout ps2_data,
	input up,
	input down,
	input left,
	input right,
	input pin0,
	input pin1,
	input pin2,
	input pin3,
	input pin5,
	output pin6,
	input pin8,
	output[7:0] buttons);
	
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
		.MEMFILE({FILES_PATH, "bkg_homescreentest.mem"})) 	// Memory initialization
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



	// buttons!
	ControllerController ctrlr( buttons,
								pin0, pin1, pin2, pin3, pin5, pin6, pin8,
								clk25);

	wire button_color;
	assign button_color = color0; // let's try black

		// GAME
	wire [7:0] g_l = 52;	wire [6:0] g_t = 50;	wire [7:0] g_r = 109;	wire [6:0] g_b = 53;

    	// CONTROLLER
	wire [7:0] c_l = 13;	wire [6:0] c_t = 90;	wire [7:0] c_r = 68;	wire [6:0] c_b = 92;

    	// SETTINGS
	wire [7:0] s_l = 100;	wire [6:0] s_t = 90;	wire [7:0] s_r = 142;	wire [6:0] s_b = 92;

 
		// inside a selection?
	reg inGAME, inCTRL, inSTGS;
	always @(posedge clk25) begin
	   	inGAME	<=	x_adj >= g_l &
					x_adj <  g_r &
					y_adj >= g_t &
					y_adj <  g_b;
		inCTRL 	<=	x_adj >= c_l &
					x_adj <  c_r &
					y_adj >= c_t &
					y_adj <  c_b;
		inSTGS 	<=	x_adj >= s_l &
					x_adj <  s_r &
					y_adj >= s_t &
					y_adj <  s_b;
	end
	


	// Quickly assign the output colors to their channels using concatenation
    wire [1:0] sel;
    HomescreenFSM fsm(sel, buttons, clk, 1'b1, reset);
	wire onGAME, onCTRL, onSTGS;
	assign onGAME   = inGAME & (~sel[1] & ~sel[0]);  // state 00 = GAME
    assign onCTRL   = inCTRL & (~sel[1] &  sel[0]);  // state 01 = CONTROLLER
    assign onSTGS   = inSTGS & ( sel[1] & ~sel[0]);  // state 10 = SETTINGS

	
	wire onSELECTION = onGAME | onCTRL | onSTGS;

	assign {VGA_R, VGA_G, VGA_B} = onSELECTION ? color0 : colorOut;
endmodule