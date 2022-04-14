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
	input clk25,
	input reset, 		// Reset Signal
	input[11:0] color0, // trim color
	input[11:0] color1, // background color
	output hSync, 		// H Sync Signal
	output vSync, 		// Veritcal Sync Signal
	output[3:0] VGA_R,  // Red Signal Bits
	output[3:0] VGA_G,  // Green Signal Bits
	output[3:0] VGA_B,  // D Signal Bits
	input[7:0] buttons, // controller buttons
	input fsm_en,		// enable homescreen fsm
	output[1:0] chc,	// current state (choice)
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
		PALETTE_ADDRESS_WIDTH = $clog2(PALETTE_COLOR_COUNT) + 1; // Use built in log2 Command

	wire[PIXEL_ADDRESS_WIDTH-1:0] imgAddress;  	// Image address for the image data
	assign imgAddress = x_adj + 160*y_adj; 		// Address calculated coordinate
	wire colorAddr; 							// Color address for the color palette
	
	GRAM #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(1),      // Set data width according to the color palette
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "bkg_colors.mem"})) 	// Memory initialization
	ImageData(
		.clk(clk), 						 // Falling edge of the 100 MHz clk
		.addr(imgAddress),					 // Image data address
		.dataOut(colorAddr),				 // Color palette address
		.wEn(1'b0)); 						 // We're always reading

	// Color Palette to Map Color Address to 12-Bit Color
	wire[11:0] colorData; // 12-bit color data at current pixel
	

	// Assign to output color from register if active
	wire[BITS_PER_COLOR-1:0] colorOut;		  // Output color
	//assign colorData = colorAddr ? color1 : color0;



	wire button_color;
	assign button_color = color0;

		// A
	wire [7:0] A0_l = 4;	wire [6:0] A0_t = 48;	wire [7:0] A0_r = 75;	wire [6:0] A0_b = 50;
	wire [7:0] A1_l = 72;	wire [6:0] A1_t = 29;	wire [7:0] A1_r = 75;	wire [6:0] A1_b = 32;

		// B
	wire [7:0] B0_l = 85;	wire [6:0] B0_t = 48;	wire [7:0] B0_r = 156;	wire [6:0] B0_b = 50;
	wire [7:0] B1_l = 153;	wire [6:0] B1_t = 29;	wire [7:0] B1_r = 156;	wire [6:0] B1_b = 32;

    	// C
	wire [7:0] C0_l = 4;	wire [6:0] C0_t = 87;	wire [7:0] C0_r = 75;	wire [6:0] C0_b = 89;	
	wire [7:0] C1_l = 72;	wire [6:0] C1_t = 68;	wire [7:0] C1_r = 75;	wire [6:0] C1_b = 71;

		// D
	wire [7:0] D0_l = 85;	wire [6:0] D0_t = 87;	wire [7:0] D0_r = 156;	wire [6:0] D0_b = 89;
	wire [7:0] D1_l = 153;	wire [6:0] D1_t = 68;	wire [7:0] D1_r = 156;	wire [6:0] D1_b = 71;
 
		// inside a selection? 0 denotes mouseover, 1 denotes choice
	reg inA0, inA1;
	reg inB0, inB1;
	reg inC0, inC1;
	reg inD0, inD1;
	always @(posedge clk25) begin
	   	inA0	<=	x_adj >= A0_l &
					x_adj <  A0_r &
					y_adj >= A0_t &
					y_adj <  A0_b;
		inA1	<=	x_adj >= A1_l &
					x_adj <  A1_r &
					y_adj >= A1_t &
					y_adj <  A1_b;
		
		inB0	<=	x_adj >= B0_l &
					x_adj <  B0_r &
					y_adj >= B0_t &
					y_adj <  B0_b;
		inB1	<=	x_adj >= B1_l &
					x_adj <  B1_r &
					y_adj >= B1_t &
					y_adj <  B1_b;

		inC0	<=	x_adj >= C0_l &
					x_adj <  C0_r &
					y_adj >= C0_t &
					y_adj <  C0_b;
		inC1	<=	x_adj >= C1_l &
					x_adj <  C1_r &
					y_adj >= C1_t &
					y_adj <  C1_b;
		
		inD0	<=	x_adj >= D0_l &
					x_adj <  D0_r &
					y_adj >= D0_t &
					y_adj <  D0_b;
		inD1	<=	x_adj >= D1_l &
					x_adj <  D1_r &
					y_adj >= D1_t &
					y_adj <  D1_b;
	end
	


	// Quickly assign the output colors to their channels using concatenation
	wire [1:0] sel;
    ColorsFSM fsm(sel, chc, buttons, clk25, fsm_en, reset);
	
	wire onA0, onA1;
	assign onA0	= inA0 & (~sel[1] & ~sel[0]);  // state 00 = A
	assign onA1	= inA1 & (~chc[1] & ~chc[0]);

	wire onB0, onB1;
	assign onB0	= inB0 & (~sel[1] &  sel[0]);  // state 01 = B
	assign onB1	= inB1 & (~chc[1] &  chc[0]);

	wire onC0, onC1;
	assign onC0	= inC0 & ( sel[1] &  ~sel[0]);  // state 10 = C
	assign onC1	= inC1 & ( chc[1] &  ~chc[0]);

	wire onD0, onD1;
	assign onD0	= inD0 & ( sel[1] &  sel[0]);  // state 11 = D
	assign onD1	= inD1 & ( chc[1] &  chc[0]);

	
	wire onSELECTION 	= onA0 | onB0 | onC0 | onD0;
	wire onCHOICE 		= onA1 | onB1 | onC1 | onD1;

	assign {VGA_R, VGA_G, VGA_B} = ~onSELECTION & ~onCHOICE & ~colorAddr ? color0 : color1;
endmodule