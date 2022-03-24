module signext17_32(out, in);
    input [16:0] in;
    output [31:0] out;

    assign out[16:0] = in[16:0];
    assign out[31:17] = in[16] ? 15'b111111111111111 : 15'b000000000000000;
endmodule