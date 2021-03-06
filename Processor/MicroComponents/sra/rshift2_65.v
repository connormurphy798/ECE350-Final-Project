module rshift2_65(out, a, shift);
    input shift;
    input [64:0] a;
    output [64:0] out;

    assign out[64] = shift ? a[64] : a[64];
    assign out[63] = shift ? a[64] : a[63];
    assign out[62] = shift ? a[64] : a[62];
    assign out[61] = shift ? a[63] : a[61];
    assign out[60] = shift ? a[62] : a[60];
    assign out[59] = shift ? a[61] : a[59];
    assign out[58] = shift ? a[60] : a[58];
    assign out[57] = shift ? a[59] : a[57];
    assign out[56] = shift ? a[58] : a[56];
    assign out[55] = shift ? a[57] : a[55];
    assign out[54] = shift ? a[56] : a[54];
    assign out[53] = shift ? a[55] : a[53];
    assign out[52] = shift ? a[54] : a[52];
    assign out[51] = shift ? a[53] : a[51];
    assign out[50] = shift ? a[52] : a[50];
    assign out[49] = shift ? a[51] : a[49];
    assign out[48] = shift ? a[50] : a[48];
    assign out[47] = shift ? a[49] : a[47];
    assign out[46] = shift ? a[48] : a[46];
    assign out[45] = shift ? a[47] : a[45];
    assign out[44] = shift ? a[46] : a[44];
    assign out[43] = shift ? a[45] : a[43];
    assign out[42] = shift ? a[44] : a[42];
    assign out[41] = shift ? a[43] : a[41];
    assign out[40] = shift ? a[42] : a[40];
    assign out[39] = shift ? a[41] : a[39];
    assign out[38] = shift ? a[40] : a[38];
    assign out[37] = shift ? a[39] : a[37];
    assign out[36] = shift ? a[38] : a[36];
    assign out[35] = shift ? a[37] : a[35];
    assign out[34] = shift ? a[36] : a[34];
    assign out[33] = shift ? a[35] : a[33];

    assign out[32] = shift ? a[34] : a[32];
    assign out[31] = shift ? a[33] : a[31];
    assign out[30] = shift ? a[32] : a[30];
    assign out[29] = shift ? a[31] : a[29];
    assign out[28] = shift ? a[30] : a[28];
    assign out[27] = shift ? a[29] : a[27];
    assign out[26] = shift ? a[28] : a[26];
    assign out[25] = shift ? a[27] : a[25];
    assign out[24] = shift ? a[26] : a[24];
    assign out[23] = shift ? a[25] : a[23];
    assign out[22] = shift ? a[24] : a[22];
    assign out[21] = shift ? a[23] : a[21];
    assign out[20] = shift ? a[22] : a[20];
    assign out[19] = shift ? a[21] : a[19];
    assign out[18] = shift ? a[20] : a[18];
    assign out[17] = shift ? a[19] : a[17];
    assign out[16] = shift ? a[18] : a[16];
    assign out[15] = shift ? a[17] : a[15];
    assign out[14] = shift ? a[16] : a[14];
    assign out[13] = shift ? a[15] : a[13];
    assign out[12] = shift ? a[14] : a[12];
    assign out[11] = shift ? a[13] : a[11];
    assign out[10] = shift ? a[12] : a[10];
    assign out[9]  = shift ? a[11] : a[9] ;
    assign out[8]  = shift ? a[10] : a[8] ;
    assign out[7]  = shift ? a[9]  : a[7] ;
    assign out[6]  = shift ? a[8]  : a[6] ;
    assign out[5]  = shift ? a[7]  : a[5] ;
    assign out[4]  = shift ? a[6]  : a[4] ;
    assign out[3]  = shift ? a[5]  : a[3] ;
    assign out[2]  = shift ? a[4]  : a[2] ;
    assign out[1]  = shift ? a[3]  : a[1] ;

    assign out[0]  = shift ? a[2]  : a[0] ; 
endmodule