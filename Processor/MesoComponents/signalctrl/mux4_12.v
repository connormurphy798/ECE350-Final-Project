module mux4_12(out, select, in0, in1, in2, in3);
    input [1:0] select;
    input [11:0] in0, in1, in2, in3;
    output [11:0] out;
    wire [11:0] w1, w2;
    mux2_12 first_top(w1, select[0], in0, in1);
    mux2_12 first_bottom(w2, select[0], in2, in3);
    mux2_12 second(out, select[1], w1, w2);
endmodule