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
    output[3:0] curr
    );

    // buttons
    ControllerController ctrlr(buttons, pin0, pin1, pin2, pin3, pin5, pin6, pin8, clk);

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

    UserInterfaceFSM uifsm(curr, buttons, clk, 1'b1, reset | forcereset);

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


    // -------------------- all the different possible VGA screens ------------------------
    
    // WELCOME
    wire hSync000, vSync000;
    wire [3:0] VGA_R000, VGA_G000, VGA_B000;
    VGAWelcome welcome( .clk(clk), .reset(reset),
	                    .hSync(hSync000), .vSync(vSync000),
                        .VGA_R(VGA_R000), .VGA_G(VGA_G000), .VGA_B(VGA_B000),
                        .buttons(buttons)
                        );
    
    // HOMESCREEN
    wire hSync001, vSync001;
    wire [3:0] VGA_R001, VGA_G001, VGA_B001;
    VGAHomescreen homescreen(   .clk(clk), .reset(reset),
	                            .hSync(hSync001), .vSync(vSync001),
                                .VGA_R(VGA_R001), .VGA_G(VGA_G001), .VGA_B(VGA_B001),
                                .buttons(buttons)
                                );
    
    // CONTROLLER
    wire hSync010, vSync010;
    wire [3:0] VGA_R010, VGA_G010, VGA_B010;
    VGATestController controller(   .clk(clk), .reset(reset),
	                                .hSync(hSync010), .vSync(vSync010),
                                    .VGA_R(VGA_R010), .VGA_G(VGA_G010), .VGA_B(VGA_B010),
                                    .buttons(buttons)
                                    );

    
    // select which ones are to be read
    mux8_1 hsync(   hSync, display,
                    hSync000, hSync001, hSync010, hSync001,
                    hSync001, hSync001, hSync001, hSync001);
    mux8_1 vsync(   vSync, display,
                    vSync000, vSync001, vSync010, vSync001,
                    vSync001, vSync001, vSync001, vSync001);

    mux8_4 vga_r(   VGA_R, display,
                    VGA_R000, VGA_R001, VGA_R010, VGA_R001,
                    VGA_R001, VGA_R001, VGA_R001, VGA_R001);
    mux8_4 vga_g(   VGA_G, display,
                    VGA_G000, VGA_R001, VGA_R010, VGA_R001,
                    VGA_G001, VGA_R001, VGA_R001, VGA_R001);
    mux8_4 vga_b(   VGA_B, display,
                    VGA_B000, VGA_B001, VGA_B010, VGA_B001,
                    VGA_B001, VGA_B001, VGA_B001, VGA_B001);  
    


endmodule