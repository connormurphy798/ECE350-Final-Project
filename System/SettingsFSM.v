/**
 *
 *  Hardware finite state machine representing the state of the settings menu.
 *
 **/


module SettingsFSM(curr, volume, color, buttons, clk, en, rst);
    input [7:0] buttons;    // {Start, C, B, A, Right, Left, Down, Up}
    input clk, en, rst;

    output curr;            // current state - equal to output
    output [2:0] volume;    // volume (0 to 5)
    output [1:0] color;     // color (0 to 3)

    // state logic:
    //      0: Volume
    //      1: Color palette
    wire next;           // next state
    wire U = buttons[0];    wire D = buttons[1];    wire L = buttons[2];    wire R = buttons[3];

    assign next[0] =    (~curr &  R) |
                        ( curr & ~L);
    

    // d flip flop
    dffe_ref Q(curr, next, clk, en, rst);

    // FSMs for volume and color
endmodule