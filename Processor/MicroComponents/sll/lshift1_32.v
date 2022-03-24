module lshift1_32(out, a, shift);
    input shift;
    input [31:0] a;
    output [31:0] out;
    wire zero;

    assign zero = 0;

    assign out[31] = shift ? a[30] : a[31];
    assign out[30] = shift ? a[29] : a[30];
    assign out[29] = shift ? a[28] : a[29];
    assign out[28] = shift ? a[27] : a[28];
    assign out[27] = shift ? a[26] : a[27];
    assign out[26] = shift ? a[25] : a[26];
    assign out[25] = shift ? a[24] : a[25];
    assign out[24] = shift ? a[23] : a[24];
    assign out[23] = shift ? a[22] : a[23];
    assign out[22] = shift ? a[21] : a[22];
    assign out[21] = shift ? a[20] : a[21];
    assign out[20] = shift ? a[19] : a[20];
    assign out[19] = shift ? a[18] : a[19];
    assign out[18] = shift ? a[17] : a[18];
    assign out[17] = shift ? a[16] : a[17];
    assign out[16] = shift ? a[15] : a[16];
    assign out[15] = shift ? a[14] : a[15];
    assign out[14] = shift ? a[13] : a[14];
    assign out[13] = shift ? a[12] : a[13];
    assign out[12] = shift ? a[11] : a[12];
    assign out[11] = shift ? a[10] : a[11];
    assign out[10] = shift ? a[9]  : a[10];
    assign out[9]  = shift ? a[8]  : a[9] ;
    assign out[8]  = shift ? a[7]  : a[8] ;
    assign out[7]  = shift ? a[6]  : a[7] ;
    assign out[6]  = shift ? a[5]  : a[6] ;
    assign out[5]  = shift ? a[4]  : a[5] ;
    assign out[4]  = shift ? a[3]  : a[4] ;
    assign out[3]  = shift ? a[2]  : a[3] ;
    assign out[2]  = shift ? a[1]  : a[2] ;
    assign out[1]  = shift ? a[0]  : a[1] ;
    assign out[0]  = shift ? zero  : a[0] ; 
endmodule 