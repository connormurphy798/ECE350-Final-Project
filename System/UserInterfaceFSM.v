/**
 *
 *  Hardware finite state machine representing the state of the GuyBox UI.
 *
 **/


module UserInterfaceFSM(curr, buttons, clk, en, rst);
    input [7:0] buttons;    // {Start, C, B, A, Right, Left, Down, Up}
    input clk, en, rst;

    output [1:0] curr;         // current state using modified 4-bit one-hot encoding
    /*wire C4 = curr[4];  wire C3 = curr[3];  wire C2 = curr[2]; */ wire C1 = curr[1];  wire C0 = curr[0];

    // state logic:
    //      0000: welcome to guy city   (unreachable except on boot)
    //      0001: homescreen
    //      0010: controller test
    //      0100: settings
    //      1000: game

    wire [1:0] next;
    wire U = buttons[0];    wire D = buttons[1];    wire L = buttons[2];    wire R = buttons[3];
    wire A = buttons[4];    wire B = buttons[5];    wire C = buttons[6];    wire S = buttons[7];

    // homescreen
    wire [1:0] HOME_state;
    HomescreenFSM homescreen(HOME_state, buttons[3:0], clk, C0, rst);  // only enable when at homescreen

    assign next[1] =    (C0 & A) |
                        (C1 & ~B);
    
    assign next[0] =    (~C0 & ~C1 & A) |
                        (C1 & B) |
                        (C0 & ~A); 
    
    // d flip flops
    //dffe_ref Q3(curr[3], next[3], clk, en, rst);
    //dffe_ref Q2(curr[2], next[2], clk, en, rst);
    dffe_ref Q1(curr[1], next[1], clk, en, rst);
    dffe_ref Q0(curr[0], next[0], clk, en, rst);



endmodule
