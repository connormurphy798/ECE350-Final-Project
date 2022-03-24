module reg32b(reg_out, reg_in, clk, en, clr);
    input [31:0] reg_in;
    input clk, en, clr;
    output [31:0] reg_out;

    dffe_ref dff00(reg_out[0],  reg_in[0],  clk, en, clr);
    dffe_ref dff01(reg_out[1],  reg_in[1],  clk, en, clr);
    dffe_ref dff02(reg_out[2],  reg_in[2],  clk, en, clr);
    dffe_ref dff03(reg_out[3],  reg_in[3],  clk, en, clr);
    dffe_ref dff04(reg_out[4],  reg_in[4],  clk, en, clr);
    dffe_ref dff05(reg_out[5],  reg_in[5],  clk, en, clr);
    dffe_ref dff06(reg_out[6],  reg_in[6],  clk, en, clr);
    dffe_ref dff07(reg_out[7],  reg_in[7],  clk, en, clr);
    dffe_ref dff08(reg_out[8],  reg_in[8],  clk, en, clr);
    dffe_ref dff09(reg_out[9],  reg_in[9],  clk, en, clr);
    dffe_ref dff10(reg_out[10], reg_in[10], clk, en, clr);
    dffe_ref dff11(reg_out[11], reg_in[11], clk, en, clr);
    dffe_ref dff12(reg_out[12], reg_in[12], clk, en, clr);
    dffe_ref dff13(reg_out[13], reg_in[13], clk, en, clr);
    dffe_ref dff14(reg_out[14], reg_in[14], clk, en, clr);
    dffe_ref dff15(reg_out[15], reg_in[15], clk, en, clr);
    dffe_ref dff16(reg_out[16], reg_in[16], clk, en, clr);
    dffe_ref dff17(reg_out[17], reg_in[17], clk, en, clr);
    dffe_ref dff18(reg_out[18], reg_in[18], clk, en, clr);
    dffe_ref dff19(reg_out[19], reg_in[19], clk, en, clr);
    dffe_ref dff20(reg_out[20], reg_in[20], clk, en, clr);
    dffe_ref dff21(reg_out[21], reg_in[21], clk, en, clr);
    dffe_ref dff22(reg_out[22], reg_in[22], clk, en, clr);
    dffe_ref dff23(reg_out[23], reg_in[23], clk, en, clr);
    dffe_ref dff24(reg_out[24], reg_in[24], clk, en, clr);
    dffe_ref dff25(reg_out[25], reg_in[25], clk, en, clr);
    dffe_ref dff26(reg_out[26], reg_in[26], clk, en, clr);
    dffe_ref dff27(reg_out[27], reg_in[27], clk, en, clr);
    dffe_ref dff28(reg_out[28], reg_in[28], clk, en, clr);
    dffe_ref dff29(reg_out[29], reg_in[29], clk, en, clr);
    dffe_ref dff30(reg_out[30], reg_in[30], clk, en, clr);
    dffe_ref dff31(reg_out[31], reg_in[31], clk, en, clr);

endmodule