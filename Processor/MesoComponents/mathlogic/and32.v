module and32(out, a, b);
    input [31:0] a, b;
    output [31:0] out;

    and and_in31(out[31], a[31], b[31]);
    and and_in30(out[30], a[30], b[30]);
    and and_in29(out[29], a[29], b[29]);
    and and_in28(out[28], a[28], b[28]);
    and and_in27(out[27], a[27], b[27]);
    and and_in26(out[26], a[26], b[26]);
    and and_in25(out[25], a[25], b[25]);
    and and_in24(out[24], a[24], b[24]);

    and and_in23(out[23], a[23], b[23]);
    and and_in22(out[22], a[22], b[22]);
    and and_in21(out[21], a[21], b[21]);
    and and_in20(out[20], a[20], b[20]);
    and and_in19(out[19], a[19], b[19]);
    and and_in18(out[18], a[18], b[18]);
    and and_in17(out[17], a[17], b[17]);
    and and_in16(out[16], a[16], b[16]);

    and and_in15(out[15], a[15], b[15]);
    and and_in14(out[14], a[14], b[14]);
    and and_in13(out[13], a[13], b[13]);
    and and_in12(out[12], a[12], b[12]);
    and and_in11(out[11], a[11], b[11]);
    and and_in10(out[10], a[10], b[10]);
    and and_in09(out[9] , a[9] , b[9] );
    and and_in08(out[8] , a[8] , b[8] );

    and and_in07(out[7] , a[7] , b[7] );
    and and_in06(out[6] , a[6] , b[6] );
    and and_in05(out[5] , a[5] , b[5] );
    and and_in04(out[4] , a[4] , b[4] );
    and and_in03(out[3] , a[3] , b[3] );
    and and_in02(out[2] , a[2] , b[2] );
    and and_in01(out[1] , a[1] , b[1] );
    and and_in00(out[0] , a[0] , b[0] );
endmodule