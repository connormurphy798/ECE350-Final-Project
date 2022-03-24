module instr_decoder(opcode, rd, rs, rt, shamt, ALUop, imm, target, INSTR);
    input [31:0] INSTR;
    
    output [4:0] opcode, rd, rs, rt, shamt, ALUop;
    output [16:0] imm;
    output [26:0] target;

    assign opcode = INSTR[31:27];
    assign rd     = INSTR[26:22];
    assign rs     = INSTR[21:17];
    assign rt     = INSTR[16:12];
    assign shamt  = INSTR[11:7];
    //assign ALUop  = INSTR[6:2];
    assign imm    = INSTR[16:0];
    assign target = INSTR[26:0];

    // where does the ALUop come from, the instruction directly (0) or via some lookup table (1)?
    wire ALUopSrc;
    or opsrc(ALUopSrc, opcode[0], opcode[1], opcode[2], opcode[3], opcode[4]); // true if not R-type

    // change this later, but for basic arithmetic we can assume all non-R type instructions have ALUop 00000 (addition)
    assign ALUop = ALUopSrc ? 5'b0 : INSTR[6:2];

endmodule