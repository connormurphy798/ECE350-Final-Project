module lshift_32(out, a, shamt);
    // inputs and outputs
    input [31:0] a;
    input [4:0] shamt;
    output [31:0] out;
    wire [31:0] out16, out8, out4, out2;

    // barrel shift moment
    lshift16_32 shift16(out16, a, shamt[4]);
    lshift8_32 shift8(out8, out16, shamt[3]);
    lshift4_32 shift4(out4, out8, shamt[2]);
    lshift2_32 shift2(out2, out4, shamt[1]);
    lshift1_32 shift1(out, out2, shamt[0]);
endmodule