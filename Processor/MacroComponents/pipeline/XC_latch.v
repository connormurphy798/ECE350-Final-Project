module XC_latch(A_out, B_out, I_out,
                A_in,  B_in,  I_in,
                clk, en, clr);
    input [31:0] A_in, B_in, I_in;
    input clk, en, clr;

    output [31:0] A_out, B_out, I_out;
    //output Y_out;

    // 32-bit register for A operand
    reg32b A_reg(A_out, A_in, clk, en, clr);

    // 32-bit register for B operand
    reg32b B_reg(B_out, B_in, clk, en, clr);

    // single dff for Y (are we currently doing a multi-cYcle operation?)
    //dffe_ref Y_dff(Y_out, Y_in, clk, en, clr);

    // 32-bit register for current instruction
    reg32b I_reg(I_out, I_in, clk, en, clr);

endmodule