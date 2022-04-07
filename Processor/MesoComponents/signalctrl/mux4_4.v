module mux4_4(out, select, in0, in1, in2, in3);
    input [1:0] select;
    input [3:0] in0, in1, in2, in3;
    output [3:0] out;
    wire [3:0] w1, w2;
    mux2_4 first_top(w1, select[0], in0, in1);
    mux2_4 first_bottom(w2, select[0], in2, in3);
    mux2_4 second(out, select[1], w1, w2);
endmodule