/**
 *
 *  Hardware finite state machine representing the state of the color palette
 *  component in the settings menu.
 *
 **/


module ColorsFSM(color_sel, color_chc, buttons, clk, en, rst);
    input [7:0] buttons;    // {Start, C, B, A, Right, Left, Down, Up}
    input clk, en, rst;

    output [1:0] color_sel;     // color mouseover (0 to 3)
    output [1:0] color_chc;     // color chosen (0 to 3)

    // state logic:
    //      00: default
    //      01: gameboy
    //      10: nightmode
    //      11: blue
    wire [1:0] next_sel;           // next state
    wire S1 = color_sel[1];
    wire S0 = color_sel[0];
    wire U = buttons[0];    wire D = buttons[1];    wire L = buttons[2];    wire R = buttons[3];    wire A = buttons[4];

    assign next_sel[1] =    (~S1 & ~S0 &  D) |
                            (~S1 &  S0 &  D) |
                            ( S1 & ~S0 & ~U) |
                            ( S1 &  S0 & ~U);
    
    assign next_sel[0] =    (~S1 & ~S0 &  R & ~U) |
                            (~S1 &  S0 & ~L & ~D) |
                            (~S1 &  S0 &       D) |
                            ( S1 & ~S0 &  R & ~U) |
                            ( S1 &  S0 & ~L & ~U) |
                            ( S1 &  S0 &       U);

    
    // d flip flops
    dffe_ref Q1_S(color_sel[1], next_sel[1], clk, en, rst);     // selection - always enabled
    dffe_ref Q0_S(color_sel[0], next_sel[0], clk, en, rst);

    dffe_ref Q1_C(color_chc[1], next_sel[1], clk, en & A, rst); // choice - enabled only when A pressed
    dffe_ref Q0_C(color_chc[0], next_sel[0], clk, en & A, rst);

    
endmodule