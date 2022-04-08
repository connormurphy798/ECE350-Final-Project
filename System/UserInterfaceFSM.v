/**
 *
 *  Hardware finite state machine representing the state of the GuyBox UI.
 *
 **/


module UserInterfaceFSM(curr, buttons, clk, en, rst);
    input [7:0] buttons;    // {Start, C, B, A, Right, Left, Down, Up}
    input clk, en, rst;

    wire C3, C2, C1, C0;
    output [3:0] curr;         // current state using modified 4-bit one-hot encoding
    assign curr[3] = C3;
    assign curr[2] = C2;
    assign curr[1] = C1;
    assign curr[0] = C0;

    wire WELCOME =      ~C3 & ~C2 & ~C1 & ~C0;
    wire HOMESCREEN =   ~C3 & ~C2 & ~C1 &  C0;
    wire CONTROLLER =   ~C3 & ~C2 &  C1 & ~C0;
    wire SETTINGS =     ~C3 &  C2 & ~C1 & ~C0;
    wire GAME =          C3 & ~C2 & ~C1 & ~C0;  

    wire N3, N2, N1, N0;

    // buttons
    wire S = buttons[7];    wire C = buttons[6];    wire B = buttons[5];    wire A = buttons[4];
    wire R = buttons[3];    wire L = buttons[2];    wire D = buttons[1];    wire U = buttons[0];

    // Clock divider 100 MHz -> 12.5 MHz
	wire clk125; // 12.5MHz clock

	reg[2:0] pixCounter = 0;      // Pixel counter to divide the clock
    assign clk125 = pixCounter[2]; // Set the clock high whenever the third bit (2) is high
	always @(posedge clk) begin
		pixCounter <= pixCounter + 1; // Since the reg is only 3 bits, it will reset every 8 cycles
	end

    // homescreen fsm, enabled when at the homescreen state
    wire [1:0] H;
    HomescreenFSM hs(H, {R, L, D, U}, clk125, en & HOMESCREEN, rst);    

    // state logic:
    //      0000: welcome to guy city   (unreachable except on boot)
    //      0001: homescreen
    //      0010: controller test
    //      0100: settings
    //      1000: game
    assign N3 = (HOMESCREEN &  A & ~S & ~H[1] & ~H[0]) |
                (GAME);
    
    assign N2 = (HOMESCREEN &  A &  H[1] & ~H[0]) |
                (SETTINGS   & ~B);
    
    assign N1 = (HOMESCREEN &  A & ~H[1] &  H[0]) |
                (CONTROLLER & ~U & ~B) |
                (CONTROLLER & ~U &  B) |
                (CONTROLLER &  U & ~B);

    assign N0 = (WELCOME    &  S & ~A) |
                (HOMESCREEN & ~A) |
                (CONTROLLER &  U &  B) |
                (SETTINGS   &  B);

    // d flip flops
    dffe_ref Q3(C3, N3, clk125, en, rst);
    dffe_ref Q2(C2, N2, clk125, en, rst);
    dffe_ref Q1(C1, N1, clk125, en, rst);
    dffe_ref Q0(C0, N0, clk125, en, rst);


endmodule
