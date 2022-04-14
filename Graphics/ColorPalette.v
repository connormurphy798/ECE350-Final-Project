/**
 *
 *  Module for deciding the color palette of the GuyBox.
 *
 **/

module ColorPalette(c0, c1, chc);
    input [1:0] chc;
    output [11:0] c0, c1;
    
    assign c0 = 12'b000000000000;

    mux4_12 choose(c1, chc,
                    12'b111011100001, // 0xEE1  yellow
                    12'b000110001000, // 0x188  cyan  
                    12'b110100010001, // 0xB11  red
                    12'b011001000000  // 0x640  brown
                    );
endmodule