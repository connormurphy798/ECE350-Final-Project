module reg65b(reg_out, reg_in, clk, en, clr);
    input [64:0] reg_in;
    input clk, en, clr;
    output [64:0] reg_out;

    // this is a 65-bit register intended for a modified Booth's algorithm multiplier.


    // extra trailing bit
    // 1 bit, reg65b[0]
    dffe_ref dff00(reg_out[0],  reg_in[0],  clk, en, clr);

    // multiplier
    // 32 bit, reg65b[32:1]
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
    dffe_ref dff32(reg_out[32], reg_in[32],  clk, en, clr);

    // current partial product
    // 32 bit, reg65b[64:33]
    dffe_ref dff33(reg_out[33], reg_in[33],  clk, en, clr);
    dffe_ref dff34(reg_out[34], reg_in[34],  clk, en, clr);
    dffe_ref dff35(reg_out[35], reg_in[35],  clk, en, clr);
    dffe_ref dff36(reg_out[36], reg_in[36],  clk, en, clr);
    dffe_ref dff37(reg_out[37], reg_in[37],  clk, en, clr);
    dffe_ref dff38(reg_out[38], reg_in[38],  clk, en, clr);
    dffe_ref dff39(reg_out[39], reg_in[39],  clk, en, clr);
    dffe_ref dff40(reg_out[40], reg_in[40],  clk, en, clr);
    dffe_ref dff41(reg_out[41], reg_in[41],  clk, en, clr);
    dffe_ref dff42(reg_out[42], reg_in[42], clk, en, clr);
    dffe_ref dff43(reg_out[43], reg_in[43], clk, en, clr);
    dffe_ref dff44(reg_out[44], reg_in[44], clk, en, clr);
    dffe_ref dff45(reg_out[45], reg_in[45], clk, en, clr);
    dffe_ref dff46(reg_out[46], reg_in[46], clk, en, clr);
    dffe_ref dff47(reg_out[47], reg_in[47], clk, en, clr);
    dffe_ref dff48(reg_out[48], reg_in[48], clk, en, clr);
    dffe_ref dff49(reg_out[49], reg_in[49], clk, en, clr);
    dffe_ref dff50(reg_out[50], reg_in[50], clk, en, clr);
    dffe_ref dff51(reg_out[51], reg_in[51], clk, en, clr);
    dffe_ref dff52(reg_out[52], reg_in[52], clk, en, clr);
    dffe_ref dff53(reg_out[53], reg_in[53], clk, en, clr);
    dffe_ref dff54(reg_out[54], reg_in[54], clk, en, clr);
    dffe_ref dff55(reg_out[55], reg_in[55], clk, en, clr);
    dffe_ref dff56(reg_out[56], reg_in[56], clk, en, clr);
    dffe_ref dff57(reg_out[57], reg_in[57], clk, en, clr);
    dffe_ref dff58(reg_out[58], reg_in[58], clk, en, clr);
    dffe_ref dff59(reg_out[59], reg_in[59], clk, en, clr);
    dffe_ref dff60(reg_out[60], reg_in[60], clk, en, clr);
    dffe_ref dff61(reg_out[61], reg_in[61], clk, en, clr);
    dffe_ref dff62(reg_out[62], reg_in[62], clk, en, clr);
    dffe_ref dff63(reg_out[63], reg_in[63], clk, en, clr);
    dffe_ref dff64(reg_out[64], reg_in[64], clk, en, clr);

endmodule