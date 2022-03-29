module reads_rd(reads, instr);
    input [31:0] instr;
    output reads;

    // get the opcode wires
    wire [4:0] opcode = instr[31:27];
    wire o0, o1, o2, o3, o4;
    assign o0 = opcode[0];
    assign o1 = opcode[1];
    assign o2 = opcode[2];
    assign o3 = opcode[3];
    assign o4 = opcode[4];

    // reads is 1 if instr reads $rd, 0 otherwise.
    wire r1, r2;
    assign r1 = (~o4 & ~o3 &  o2 &  o1      ) | // 0011x sw/blt
                (~o4 & ~o3 & ~o2 &  o1 & ~o0) | // 00010 bne
                (~o4 & ~o3 &  o2 & ~o1 & ~o0);  // 00100 jr
    assign r2 = ( o4 &  o3 & ~o2 & ~o1 &  o0) | // 11001 beq
                ( o4 & ~o3 &  o2 &  o1 & ~o0) | // 10110 bex
                ( o4 &  o3 & ~o2 &  o1 & ~o0);  // 11010 ren

    assign reads  = r1 | r2;


endmodule