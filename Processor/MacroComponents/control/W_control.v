module W_control(RegWE, RegWDest, WrSrc, BVal, instr, controller);
    input [31:0] instr;
    input [7:0] controller;

    output [4:0] RegWDest;
    output [1:0] WrSrc;
    output RegWE, BVal;

    // instruction decoder
    wire [4:0] opcode, rs, rt, rd, shamt, ALUop;
    wire [16:0] imm;
    wire [26:0] target;
    instr_decoder dcd(opcode, rd, rs, rt, shamt, ALUop, imm, target, instr);

    // set destination register - rd normally, $r30 if setx
    wire o4, o3, o2, o1, o0;
    assign o4 = opcode[4];
    assign o3 = opcode[3];
    assign o2 = opcode[2];
    assign o1 = opcode[1];
    assign o0 = opcode[0];
    assign RegWDest = ( o4 & ~o3 &  o2 & ~o1 &  o0) ? 5'b11110 : rd;


    // enable writing to registers when doing an R-type instruction, addi, lw, jal, sbp, or setx
    
    assign RegWE =  (~o4 & ~o3 & ~o2 & ~o1 & ~o0) | // 00000 R-type
                    (~o4 & ~o3 &  o2 & ~o1 &  o0) | // 00101 addi
                    (~o4 &  o3 & ~o2 & ~o1 & ~o0) | // 01000 lw
                    (~o4 & ~o3 & ~o2 &  o1 &  o0) | // 00011 jal
                    ( o4 & ~o3 &  o2 &     &  o0);  // 101x1 sbp/setx
                    

    // 00 = write from ALU output 
    // 01 = write from multdiv (0011x)
    // 10 = write from memory output (lw 01000)
    // 11 = write from controller (sbp 10111)
    assign WrSrc[0] =   (~ALUop[4] & ~ALUop[3] & ALUop[2] & ALUop[1]) |
                        ( o4 & ~o3 &  o2 &  o1 &  o0);
    assign WrSrc[1] =   (~o4 &  o3 & ~o2 & ~o1 & ~o0) |
                        ( o4 & ~o3 &  o2 &  o1 &  o0);
    

    // determine the value to be read from the controller
    button_val buttons(BVal, instr, controller);

endmodule