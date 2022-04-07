module mux2_4(out, select, in0, in1);
    input select;
    input [3:0] in0, in1;
    output [3:0] out;
    assign out = select ? in1 : in0;
endmodule