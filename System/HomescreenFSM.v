/**
 *
 *  Hardware finite state machine representing the state of the GuyBox homescreen.
 *
 **/


module HomescreenFSM(curr, buttons, clk, en, rst);
    input [3:0] buttons;    // {Right, Left, Down, Up}
    input clk, en, rst;

    output [1:0] curr;         // current state - equal to output

    // state logic:
    //      00: game
    //      01: controller test
    //      10: settings
    wire [1:0] next;           // next state
    wire U = buttons[0];    wire D = buttons[1];    wire L = buttons[2];    wire R = buttons[3];

    assign next[1] =    (~curr[1] &  curr[0] &  R & ~U) |    
                        ( curr[1] & ~curr[0] & ~L & ~U);
    
    assign next[0] =    (~curr[1] & ~curr[0] &  D) |
                        (~curr[1] &  curr[0] & ~R & ~U) |
                        ( curr[1] & ~curr[0] &  L & ~U);
    

    // d flip flops
    dffe_ref Q1(curr[1], next[1], clk, en, rst);
    dffe_ref Q0(curr[0], next[0], clk, en, rst);
    
endmodule