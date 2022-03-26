module M_control(MemWE, BVal, sbp, instr, controller);
    input [31:0] instr;
    input [7:0] controller;

    output MemWE, BVal, sbp;

    // literally only write to memory if sw (00111)
    assign MemWE = (~instr[31] & ~instr[30] & instr[29] & instr[28] & instr[27]);

    // determine button value and whether we're doing an sbp (10111)
    button_val buttons(BVal, instr, controller);
    assign sbp   = ( instr[31] & ~instr[30] & instr[29] & instr[28] & instr[27]);
endmodule