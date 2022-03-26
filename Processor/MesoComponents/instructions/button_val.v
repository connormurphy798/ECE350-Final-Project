module button_val(bval, instr, c);
    input [31:0] instr;
    input [7:0] c;  // controller

    output bval;

    wire [2:0] code;
    assign code = instr[19:17];

    mux8_1 button(bval, code, c[0], c[1], c[2], c[3],
                                c[4], c[5], c[6], c[7]);
endmodule