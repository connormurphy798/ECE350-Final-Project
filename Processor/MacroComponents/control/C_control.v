module C_control(ctrl_MULT, ctrl_DIV, multdiving, en, instr, new, md_rdy);
    input [31:0] instr;
    input new, md_rdy;

    output ctrl_MULT, ctrl_DIV, multdiving, en;

    // instruction decoder
    wire [4:0] opcode, rd, rs, rt, shamt, ALUop;
    wire [16:0] imm;
    wire [26:0] target;
    instr_decoder dcd(opcode, rd, rs, rt, shamt, ALUop, imm, target, instr);

    // check if current instruction is a multiply or a divide
    wire multing, diving;
    assign multing = ~ALUop[4] & ~ALUop[3] & ALUop[2] & ALUop[1] & ~ALUop[0]; 
    assign diving  = ~ALUop[4] & ~ALUop[3] & ALUop[2] & ALUop[1] &  ALUop[0];

    // assert ctrl_MULT/ctrl_DIV for exactly one cycle upon receiving a mul/div instruction
    assign ctrl_MULT = new & multing;
    assign ctrl_DIV =  new & diving;

    // determine if we're actively multiplying or dividing on this cycle
    assign multdiving = (multing|diving) & ~md_rdy;
    assign en = ~multdiving;

endmodule