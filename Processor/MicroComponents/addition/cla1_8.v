module cla1_8(S, G, P, a, b, cin);
    input [7:0] a, b;
    input cin;

    output [7:0] S;
    output G, P;

    wire c1, c2, c3, c4, c5, c6, c7;
    wire g0, g1, g2, g3, g4, g5, g6, g7;
    wire p0, p1, p2, p3, p4, p5, p6, p7;

    // assign g and p values
    and g_0(g0, a[0], b[0]);
    and g_1(g1, a[1], b[1]);
    and g_2(g2, a[2], b[2]);
    and g_3(g3, a[3], b[3]);
    and g_4(g4, a[4], b[4]);
    and g_5(g5, a[5], b[5]);
    and g_6(g6, a[6], b[6]);
    and g_7(g7, a[7], b[7]);

    or p_0(p0, a[0], b[0]);
    or p_1(p1, a[1], b[1]);
    or p_2(p2, a[2], b[2]);
    or p_3(p3, a[3], b[3]);
    or p_4(p4, a[4], b[4]);
    or p_5(p5, a[5], b[5]);
    or p_6(p6, a[6], b[6]);
    or p_7(p7, a[7], b[7]);

    // c1
    wire c1_0;
    and c1_prod0(c1_0, p0, cin);

    or c1_sum(c1, g0, c1_0);

    // c2
    wire c2_0, c2_1;
    and c2_prod0(c2_0, p1, g0);
    and c2_prod1(c2_1, p1, p0, cin);

    or c2_sum(c2, g1, c2_0, c2_1);

    // c3
    wire c3_0, c3_1, c3_2;
    and c3_prod0(c3_0, p2, g1);
    and c3_prod1(c3_1, p2, p1, g0);
    and c3_prod2(c3_2, p2, p1, p0, cin);

    or c3_sum(c3, g2, c3_0, c3_1, c3_2);

    // c4
    wire c4_0, c4_1, c4_2, c4_3;
    and c4_prod0(c4_0, p3, g2);
    and c4_prod1(c4_1, p3, p2, g1);
    and c4_prod2(c4_2, p3, p2, p1, g0);
    and c4_prod3(c4_3, p3, p2, p1, p0, cin);

    or c4_sum(c4, g3, c4_0, c4_1, c4_2, c4_3);

    // c5
    wire c5_0, c5_1, c5_2, c5_3, c5_4;
    and c5_prod0(c5_0, p4, g3);
    and c5_prod1(c5_1, p4, p3, g2);
    and c5_prod2(c5_2, p4, p3, p2, g1);
    and c5_prod3(c5_3, p4, p3, p2, p1, g0);
    and c5_prod4(c5_4, p4, p3, p2, p1, p0, cin);

    or c5_sum(c5, g4, c5_0, c5_1, c5_2, c5_3, c5_4);

    // c6
    wire c6_0, c6_1, c6_2, c6_3, c6_4, c6_5;
    and c6_prod0(c6_0, p5, g4);
    and c6_prod1(c6_1, p5, p4, g3);
    and c6_prod2(c6_2, p5, p4, p3, g2);
    and c6_prod3(c6_3, p5, p4, p3, p2, g1);
    and c6_prod4(c6_4, p5, p4, p3, p2, p1, g0);
    and c6_prod5(c6_5, p5, p4, p3, p2, p1, p0, cin);

    or c6_sum(c6, g5, c6_0, c6_1, c6_2, c6_3, c6_4, c6_5);

    // c7
    wire c7_0, c7_1, c7_2, c7_3, c7_4, c7_5, c7_6;
    and c7_prod0(c7_0, p6, g5);
    and c7_prod1(c7_1, p6, p5, g4);
    and c7_prod2(c7_2, p6, p5, p4, g3);
    and c7_prod3(c7_3, p6, p5, p4, p3, g2);
    and c7_prod4(c7_4, p6, p5, p4, p3, p2, g1);
    and c7_prod5(c7_5, p6, p5, p4, p3, p2, p1, g0);
    and c7_prod6(c7_6, p6, p5, p4, p3, p2, p1, p0, cin);

    or c7_sum(c7, g6, c7_0, c7_1, c7_2, c7_3, c7_4, c7_5, c7_6);

    
    // now do the adding
    wire w0, w1, w2, w3, w4, w5, w6, w7; // accept the carry and do nothing with it

    full_adder add0(S[0], w0, a[0], b[0], cin);
    full_adder add1(S[1], w1, a[1], b[1], c1);
    full_adder add2(S[2], w2, a[2], b[2], c2);
    full_adder add3(S[3], w3, a[3], b[3], c3);
    full_adder add4(S[4], w4, a[4], b[4], c4);
    full_adder add5(S[5], w5, a[5], b[5], c5);
    full_adder add6(S[6], w6, a[6], b[6], c6);
    full_adder add7(S[7], w7, a[7], b[7], c7);
    
    // G and P
    and P_0(P, p7, p6, p5, p4, p3, p2, p1, p0);

    wire G_0, G_1, G_2, G_3, G_4, G_5, G_6;
    and G_prod0(G_0, p7, g6);
    and G_prod1(G_1, p7, p6, g5);
    and G_prod2(G_2, p7, p6, p5, g4);
    and G_prod3(G_3, p7, p6, p5, p4, g3);
    and G_prod4(G_4, p7, p6, p5, p4, p3, g2);
    and G_prod5(G_5, p7, p6, p5, p4, p3, p2, g1);
    and G_prod6(G_6, p7, p6, p5, p4, p3, p2, p1, g0);
    or G_0(G, g7, G_0, G_1, G_2, G_3, G_4, G_5, G_6);

endmodule