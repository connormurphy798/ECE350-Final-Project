module mux2_12(out, select, in0, in1);
    input select;
    input [11:0] in0, in1;
    output [11:0] out;
    assign out = select ? in1 : in0;
endmodule