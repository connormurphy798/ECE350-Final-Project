module reads_rt(reads, instr);
    input [31:0] instr;
    output reads;

    // an instruction reads $rt if it's an R-type instruction or a ren.
    // this isn't true of shifts, but it doesn't matter because their ALUinB doesn't matter
    assign reads =  (~instr[31] & ~instr[30] & ~instr[29] & ~instr[28] & ~instr[27]) |
                    ( instr[31] &  instr[30] & ~instr[29] &  instr[28] & ~instr[27]);
endmodule