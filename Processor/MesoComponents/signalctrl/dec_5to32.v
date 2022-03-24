module dec_5to32(dec_out, code);
    input [4:0] code;
    output [31:0] dec_out;

    lshift_32 dcd(dec_out, 32'b00000000000000000000000000000001, code);
endmodule