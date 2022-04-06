/**
 *
 *  Hardware finite state machine representing the state of the GuyBox UI.
 *
 **/


module UserInterfaceFSM(curr, buttons, clk, en, rst);
    input [7:0] buttons;    // {Start, C, B, A, Right, Left, Down, Up}
    input clk, en, rst;

    output [2:0] curr;         // current state - equal to output
    wire C2 = curr[2];  wire C1 = curr[1];  wire C0 = curr[0]; 

    // state logic:
    //      000: welcome to guy city
    //      001: homescreen
    //      010: controller test
    //      011: (unused)
    //      100: settings
    //      101: volume
    //      110: color palette
    //      111: game

    wire [1:0] HOME_state;
    HomescreenFSM homescreen(HOME_state, buttons, clk, (~C2 & ~C1 & C0), rst);  // only enable when on homescreen


endmodule
