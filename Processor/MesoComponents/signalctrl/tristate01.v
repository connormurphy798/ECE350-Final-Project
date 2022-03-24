module tristate01(out, in, oe);
    input in;
    input oe;
    output out;

    assign out = oe ? in : 1'bz;
endmodule