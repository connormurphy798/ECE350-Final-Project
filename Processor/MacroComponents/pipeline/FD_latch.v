module FD_latch(PC_out, I_out,
                PC_in, I_in,
                clk, en, clr);
    input [31:0] PC_in, I_in;
    input clk, en, clr;
    
    output [31:0] PC_out, I_out;

    // 32-bit register for PC
    reg32b PC_reg(PC_out, PC_in, clk, en, clr);

    // 32-bit register for current instruction
    reg32b I_reg(I_out, I_in, clk, en, clr);

endmodule