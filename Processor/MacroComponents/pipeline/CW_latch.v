module CW_latch(P_out, I_out, E_out,
                P_in,  I_in, E_in,
                clk, en, clr);
    input [31:0] P_in, I_in;
    input E_in, clk, en, clr;

    output [31:0] P_out, I_out;
    output E_out;

    // 32-bit register for P
    reg32b P_reg(P_out, P_in, clk, en, clr);

    // 32-bit register for current instruction
    reg32b I_reg(I_out, I_in, clk, en, clr);

    // dffe for exception info
    dffe_ref E_dffe(E_out, E_in, clk, en, clr);

endmodule