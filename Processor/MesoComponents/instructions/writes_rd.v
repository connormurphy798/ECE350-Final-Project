module writes_rd(writes, instr);
    input [31:0] instr;
    output writes;

    // writes is 1 if instr writes $rd, 0 otherwise.
    // instructions that write to $rd include R-type (00000), addi (00101), lw (01000), and for our purposes, setx (10101)
    assign writes = (~instr[31]              & ~instr[29] & ~instr[28] & ~instr[27]) | // 0x000 R-type/lw 
                    (             ~instr[30] &  instr[29] & ~instr[28] &  instr[27]);  // x0101 addi/setx
endmodule