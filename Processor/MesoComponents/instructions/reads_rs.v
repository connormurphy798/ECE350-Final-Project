module reads_rs(reads, instr);
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

    // reads is 1 if instr reads $rs, 0 otherwise.
    assign reads =  (~o4 & ~o3 & ~o2 & ~o1 & ~o0) | // 00000 R-type
                    (~o4 & ~o3 &  o2 & ~o1 &  o0) | // 00101 addi
                    (~o4 & ~o3 &  o2 &  o1 &  o0) | // 00111 sw
                    (~o4 &  o3 & ~o2 & ~o1 & ~o0) | // 01000 lw
                    (~o4 & ~o3 & ~o2 &  o1 & ~o0) | // 00010 bne
                    (~o4 & ~o3 &  o2 &  o1 & ~o0);  // 00110 blt
                    
endmodule