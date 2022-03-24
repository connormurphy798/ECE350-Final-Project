module not32(out, in);
    input [31:0] in;
    output [31:0] out;

    not not_in31(out[31], in[31]);
    not not_in30(out[30], in[30]);
    not not_in29(out[29], in[29]);
    not not_in28(out[28], in[28]);
    not not_in27(out[27], in[27]);
    not not_in26(out[26], in[26]);
    not not_in25(out[25], in[25]);
    not not_in24(out[24], in[24]);

    not not_in23(out[23], in[23]);
    not not_in22(out[22], in[22]);
    not not_in21(out[21], in[21]);
    not not_in20(out[20], in[20]);
    not not_in19(out[19], in[19]);
    not not_in18(out[18], in[18]);
    not not_in17(out[17], in[17]);
    not not_in16(out[16], in[16]);

    not not_in15(out[15], in[15]);
    not not_in14(out[14], in[14]);
    not not_in13(out[13], in[13]);
    not not_in12(out[12], in[12]);
    not not_in11(out[11], in[11]);
    not not_in10(out[10], in[10]);
    not not_in09(out[9] , in[9] );
    not not_in08(out[8] , in[8] );

    not not_in07(out[7] , in[7] );
    not not_in06(out[6] , in[6] );
    not not_in05(out[5] , in[5] );
    not not_in04(out[4] , in[4] );
    not not_in03(out[3] , in[3] );
    not not_in02(out[2] , in[2] );
    not not_in01(out[1] , in[1] );
    not not_in00(out[0] , in[0] );
endmodule