module PC_latch(PC_out,
                PC_in,
                clk, en, clr);
    input [31:0] PC_in;
    input clk, en, clr;
    
    output [31:0] PC_out;

    // 32-bit register for PC
    reg32b PC_reg(PC_out, PC_in, clk, en, clr);
endmodule