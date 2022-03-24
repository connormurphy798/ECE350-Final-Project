module or32(out, a, b);
    input [31:0] a, b;
    output [31:0] out;

    or or_in31(out[31], a[31], b[31]);
    or or_in30(out[30], a[30], b[30]);
    or or_in29(out[29], a[29], b[29]);
    or or_in28(out[28], a[28], b[28]);
    or or_in27(out[27], a[27], b[27]);
    or or_in26(out[26], a[26], b[26]);
    or or_in25(out[25], a[25], b[25]);
    or or_in24(out[24], a[24], b[24]);

    or or_in23(out[23], a[23], b[23]);
    or or_in22(out[22], a[22], b[22]);
    or or_in21(out[21], a[21], b[21]);
    or or_in20(out[20], a[20], b[20]);
    or or_in19(out[19], a[19], b[19]);
    or or_in18(out[18], a[18], b[18]);
    or or_in17(out[17], a[17], b[17]);
    or or_in16(out[16], a[16], b[16]);

    or or_in15(out[15], a[15], b[15]);
    or or_in14(out[14], a[14], b[14]);
    or or_in13(out[13], a[13], b[13]);
    or or_in12(out[12], a[12], b[12]);
    or or_in11(out[11], a[11], b[11]);
    or or_in10(out[10], a[10], b[10]);
    or or_in09(out[9] , a[9] , b[9] );
    or or_in08(out[8] , a[8] , b[8] );

    or or_in07(out[7] , a[7] , b[7] );
    or or_in06(out[6] , a[6] , b[6] );
    or or_in05(out[5] , a[5] , b[5] );
    or or_in04(out[4] , a[4] , b[4] );
    or or_in03(out[3] , a[3] , b[3] );
    or or_in02(out[2] , a[2] , b[2] );
    or or_in01(out[1] , a[1] , b[1] );
    or or_in00(out[0] , a[0] , b[0] );
endmodule