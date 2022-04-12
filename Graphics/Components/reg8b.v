module reg8b(reg_out, reg_in, clk, en, clr);
    input [7:0] reg_in;
    input clk, en, clr;
    output [7:0] reg_out;

    dffe_ref dff00(reg_out[0],  reg_in[0],  clk, en, clr);
    dffe_ref dff01(reg_out[1],  reg_in[1],  clk, en, clr);
    dffe_ref dff02(reg_out[2],  reg_in[2],  clk, en, clr);
    dffe_ref dff03(reg_out[3],  reg_in[3],  clk, en, clr);
    dffe_ref dff04(reg_out[4],  reg_in[4],  clk, en, clr);
    dffe_ref dff05(reg_out[5],  reg_in[5],  clk, en, clr);
    dffe_ref dff06(reg_out[6],  reg_in[6],  clk, en, clr);
    dffe_ref dff07(reg_out[7],  reg_in[7],  clk, en, clr);

endmodule