module cla_32(S, overflow, A, B, c0);
    input [31:0] A, B;
    input c0;
    output [31:0] S;
    output overflow;

    wire P0, P1, P2, P3;
    wire G0, G1, G2, G3;

    // adder0, produce adder1 carry-in
    cla1_8 adder0(S[7:0], G0, P0, A[7:0], B[7:0], c0);

    wire c8, c8_0;
    and c8_prod0(c8_0, P0, c0);
    or c8_sum(c8, G0, c8_0);


    // adder1, produce adder2 carry-in
    cla1_8 adder1(S[15:8], G1, P1, A[15:8], B[15:8], c8);

    wire c16, c16_0, c16_1;
    and c16_prod0(c16_0, P1, G0);
    and c16_prod1(c16_1, P1, P0, c0);
    or c16_sum(c16, G1, c16_0, c16_1);

    // adder2, produce adder3 carry-in
    cla1_8 adder2(S[23:16], G2, P2, A[23:16], B[23:16], c16);

    wire c24, c24_0, c24_1, c24_2;
    and c24_prod0(c24_0, P2, G1);
    and c24_prod1(c24_1, P2, P1, G0);
    and c24_prod2(c24_2, P2, P1, P0, c0);
    or c24_sum(c24, G2, c24_0, c24_1, c24_2);

    // adder3, produce final carry-out
    cla1_8 adder3(S[31:24], G3, P3, A[31:24], B[31:24], c24);

    wire c32, c32_0, c32_1, c32_2, c32_3;
    and c32_prod0(c32_0, P3, G2);
    and c32_prod1(c32_1, P3, P2, G1);
    and c32_prod2(c32_2, P3, P2, P1, G0);
    and c32_prod3(c32_3, P3, P2, P1, P0, c0);
    or c32_sum(c32, G3, c32_0, c32_1, c32_2, c32_3);



    // overflow - input MSBs are the same and not equal to output MSB
    wire notA31, notB31, notS31;
    not not_A31(notA31, A[31]);
    not not_B31(notB31, B[31]);
    not not_S31(notS31, S[31]);

    wire overflow_prod0, overflow_prod1;
    and ofp0(overflow_prod0, notA31, notB31, S[31]);
    and ofp1(overflow_prod1, A[31], B[31], notS31);
    or overflow_sum(overflow, overflow_prod0, overflow_prod1);

endmodule