module M_control(MemWE, instr);
    input [31:0] instr;

    output MemWE;

    // literally only write to memory if sw (00111)
    assign MemWE = (~instr[31] & ~instr[30] & instr[29] & instr[28] & instr[27]);
endmodule