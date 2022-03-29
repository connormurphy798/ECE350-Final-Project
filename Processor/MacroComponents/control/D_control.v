module D_control(readregA, readregB, readregC, instr);
    output [4:0] readregA, readregB, readregC;
    input [31:0] instr;

    // instruction decoder
    wire [4:0] opcode, destreg, rs, rt, shamt, ALUop;
    wire [16:0] imm;
    wire [26:0] target;
    instr_decoder dcd(opcode, destreg, rs, rt, shamt, ALUop, imm, target, instr);

    // if bex (10110), rd is $r30. else it's destreg
    wire [4:0] rd;
    assign rd = (opcode[4] & ~opcode[3] & opcode[2] & opcode[1] & ~opcode[0]) ? 5'b11110 : destreg;

    // assign readregA to $rs always
    assign readregA = rs;

    // if it's R-type (00000) or ren (11010), read from $rt. else (1), read from rd
    wire rtype, ren;
    assign rtype = ~( opcode[4] |  opcode[3] |  opcode[2] |  opcode[1] |  opcode[0]);
    assign ren   =  ( opcode[4] &  opcode[3] & ~opcode[2] &  opcode[1] & ~opcode[0]);
    wire src2;
    or notRtype(src2, opcode[0], opcode[1], opcode[2], opcode[3], opcode[4]);
    assign readregB = (rtype | ren) ? rt : rd;

    // also, just always read from $rd. (readregC is only well-defined for ren)
    assign readregC = rd;

endmodule