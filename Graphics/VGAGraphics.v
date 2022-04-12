/**
 *
 *  Module controlling the VGA graphics for the GuyBox.
 *  Organizes all the different VGA controllers for different portions of the console.
 *
 **/
 
 `timescale 1 ns/ 100 ps
module VGAGraphics(     
	input clk, 			// 100 MHz System Clock
	input reset, 		// Reset Signal
	output hSync, 		// H Sync Signal
	output vSync, 		// Veritcal Sync Signal
	output[3:0] VGA_R,  // Red Signal Bits
	output[3:0] VGA_G,  // Green Signal Bits
	output[3:0] VGA_B,  // Blue Signal Bits
	input pin0,
	input pin1,
	input pin2,
	input pin3,
	input pin5,
	output pin6,
	input pin8,
	output[7:0] buttons,
    output[3:0] curr,
    output screenEnd    // asserted for one cycle at the end of the current frame
    );

    // Clock divider 100 MHz -> 25 MHz
	wire clk25, clk125, clk0625, clk03125, clk015625;

	reg[5:0] pixCounter = 0;      // Pixel counter to divide the clock
    assign clk25 = pixCounter[1]; // Set the clock high whenever the second bit (2) is high
    assign clk125 = pixCounter[2];
    assign clk0625 = pixCounter[3];
    assign clk03125 = pixCounter[4];
    assign clk015625 = pixCounter[5];
	always @(posedge clk) begin
		pixCounter <= pixCounter + 1; // Since the reg is only 3 bits, it will reset every 8 cycles
	end


    // buttons
    ControllerController ctrlr(buttons, pin0, pin1, pin2, pin3, pin5, pin6, pin8, clk015625);

    // get the current screen to be displayed
    reg forcereset = 1;
    reg [31:0] counter = 0;
    always @(posedge clk) begin
        if (counter < 200) begin
            counter = counter + 15;
        end else begin
            counter = 300;
            forcereset = 0;
        end
    end

    wire [1:0] H;   // homescreen state
    UserInterfaceFSM uifsm(curr, buttons, H, clk, 1'b1, reset | forcereset);

    // encode current state:
    //      000: welcome
    //      001: homescreen
    //      010: controller test 
    //      011: settings
    //      100: game
    wire C3 = curr[3];  wire C2 = curr[2];  wire C1 = curr[1];  wire C0 = curr[0];
    wire [2:0] display;
    assign display[2] = ( C3 & ~C2 & ~C1 & ~C0);
    assign display[1] = (       C2 & ~C1 & ~C0) |
                        (             C1 & ~C0);
    assign display[0] = (       C2 & ~C1 & ~C0) |
                        (                   C0);

    
    // color palette
    wire [1:0] P;   // color palette selection
    wire [11:0] color0, color1;
    ColorPalette palette(.c0(color0), .c1(color1), .chc(P));


    // -------------------- all the different possible VGA screens ------------------------
    
    // WELCOME
    wire hSync000, vSync000, screenEnd000;
    wire [3:0] VGA_R000, VGA_G000, VGA_B000;
    VGAWelcome welcome( .clk(clk), .clk25(clk25), .reset(reset),
                        .color0(color0), .color1(color1),
	                    .hSync(hSync000), .vSync(vSync000),
                        .VGA_R(VGA_R000), .VGA_G(VGA_G000), .VGA_B(VGA_B000),
                        .buttons(buttons),
                        .screenEnd(screenEnd000) 
                        );
    
    // HOMESCREEN
    wire hSync001, vSync001, screenEnd001;
    wire [3:0] VGA_R001, VGA_G001, VGA_B001;
    VGAHomescreen homescreen(   .clk(clk), .clk25(clk25), .reset(reset),
                                .color0(color0), .color1(color1),
	                            .hSync(hSync001), .vSync(vSync001),
                                .VGA_R(VGA_R001), .VGA_G(VGA_G001), .VGA_B(VGA_B001),
                                .buttons(buttons), .fsm_en(~display[2] & ~display[1] & display[0]), .sel(H),
                                .screenEnd(screenEnd001) 
                                );
    
    // CONTROLLER
    wire hSync010, vSync010, screenEnd010;
    wire [3:0] VGA_R010, VGA_G010, VGA_B010;
    VGATestController controller(   .clk(clk), .clk25(clk25), .reset(reset),
                                    .color0(color0), .color1(color1),
	                                .hSync(hSync010), .vSync(vSync010),
                                    .VGA_R(VGA_R010), .VGA_G(VGA_G010), .VGA_B(VGA_B010),
                                    .buttons(buttons),
                                    .screenEnd(screenEnd010) 
                                    );
    
    // SETTINGS
    wire hSync011, vSync011, screenEnd011;
    wire [3:0] VGA_R011, VGA_G011, VGA_B011;
    VGASettings settings(   .clk(clk), .clk25(clk25), .reset(reset),
                            .color0(color0), .color1(color1),
	                        .hSync(hSync011), .vSync(vSync011),
                            .VGA_R(VGA_R011), .VGA_G(VGA_G011), .VGA_B(VGA_B011),
                            .buttons(buttons), .fsm_en(~display[2] &  display[1] & display[0]), .chc(P),
                            .screenEnd(screenEnd011)  
                            );
    
    // GAMEPLAY
    wire hSync100, vSync100, screenEnd100;
    wire [3:0] VGA_R100, VGA_G100, VGA_B100;
    VGAGame game(   .clk(clk), .clk25(clk25), .reset(reset),
                    .color0(color0), .color1(color1),
	                .hSync(hSync100), .vSync(vSync100),
                    .VGA_R(VGA_R100), .VGA_G(VGA_G100), .VGA_B(VGA_B100),
                    .buttons(buttons),
                    .screenEnd(screenEnd100),
                    .bkg_en(bkg_en), .bkg_addr(bkg_addr), .bkg_x(bkg_x), .bkg_y(bkg_y)  
                    );

    
    // select which ones are to be read
    mux8_1 hsync(   hSync, display,
                    hSync000, hSync001, hSync010, hSync011,
                    hSync100, hSync001, hSync001, hSync001);
    mux8_1 vsync(   vSync, display,
                    vSync000, vSync001, vSync010, vSync011,
                    vSync100, vSync001, vSync001, vSync001);
    mux8_1 newfr(   screenEnd, display,
                    screenEnd000, screenEnd001, screenEnd010, screenEnd011,
                    screenEnd100, screenEnd001, screenEnd001, screenEnd001);

    mux8_4 vga_r(   VGA_R, display,
                    VGA_R000, VGA_R001, VGA_R010, VGA_R011,
                    VGA_R100, VGA_R001, VGA_R001, VGA_R001);
    mux8_4 vga_g(   VGA_G, display,
                    VGA_G000, VGA_G001, VGA_G010, VGA_G011,
                    VGA_G100, VGA_G001, VGA_G001, VGA_G001);
    mux8_4 vga_b(   VGA_B, display,
                    VGA_B000, VGA_B001, VGA_B010, VGA_B011,
                    VGA_B100, VGA_B001, VGA_B001, VGA_B001);  
    


endmodule