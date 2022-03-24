module XM_latch(O_out, B_out, I_out, E_out,
                O_in, B_in, I_in, E_in,
                clk, en, clr);
    input [31:0] O_in, B_in, I_in;
    input E_in, clk, en, clr;

    output [31:0] O_out, B_out, I_out;
    output E_out;

    // 32-bit register for ALU output
    reg32b O_reg(O_out, O_in, clk, en, clr);

    // 32-bit register for B operand
    reg32b B_reg(B_out, B_in, clk, en, clr);

    // 32-bit register for current instruction
    reg32b I_reg(I_out, I_in, clk, en, clr);

    // dffe for exception info
    dffe_ref E_dffe(E_out, E_in, clk, en, clr);

endmodule