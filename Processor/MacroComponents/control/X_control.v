module X_control(ALUinB, imm32, ALUop, shamt, ctrl_MULT, ctrl_DIV, jb, target_actual, jal, setx, ren, sprite, quit_status, instr, PC, ALU_B, ne, lt, rstatus, bypexcpt, controller);
    input [31:0] instr, PC, ALU_B;
    input ne, lt;
    input [31:0] rstatus;
    input bypexcpt;
    input [7:0] controller;

    output [31:0] imm32;
    output [4:0] ALUop, shamt;
    output ALUinB;
    output ctrl_MULT, ctrl_DIV;
    output jb;
    output [31:0] target_actual;
    output jal;
    output setx;
    output ren;
    output [11:0] sprite;
    output [1:0] quit_status;

    // instruction decoder
    wire [4:0] opcode, rd, rs, rt;
    wire [16:0] imm;
    wire [26:0] target;
    instr_decoder dcd(opcode, rd, rs, rt, shamt, ALUop, imm, target, instr);

    // is the current instruction an R-type instruction?
    wire Rtype;
    nor opsrc(Rtype, opcode[0], opcode[1], opcode[2], opcode[3], opcode[4]); // only an R type if all these are 0

    // does the B operand come from an immediate (1) or $rt (0)? all instructions EXCEPT R-type + branches say 1
    wire b, bne, beq, blt, bbp;
    assign b =  bne | beq | blt | bbp;
    assign ALUinB = ~Rtype & ~b;

    // sign-extend the immediate to be 32 bits
    signext17_32 sx(imm32, imm);

    // signals to multiply (00110) or divide (00111)
    assign ctrl_MULT = ~ALUop[4] & ~ALUop[3] & ALUop[2] & ALUop[1] & ~ALUop[0];
    assign ctrl_DIV  = ~ALUop[4] & ~ALUop[3] & ALUop[2] & ALUop[1] &  ALUop[0];

    wire o4, o3, o2, o1, o0;
    assign o4 = opcode[4];
    assign o3 = opcode[3];
    assign o2 = opcode[2];
    assign o1 = opcode[1];
    assign o0 = opcode[0];

    // determine the button value
    wire bval;
    button_val buttons(bval, instr, controller);


    // j-type instructions and branches! get all the potential targets
    wire [31:0] target32, PCplusN;
    wire pcov;
    assign target32 = {5'b0, target};
    cla_32 PCadder(PCplusN, pcov, PC, imm32, 1'b1);

    // j?
    wire j;
    assign j    = (~o4 & ~o3 & ~o2 & ~o1 &  o0); // 00001 j

    // jal?
    assign jal  = (~o4 & ~o3 & ~o2 &  o1 &  o0); // 00011 jal

    // jr?
    wire jr;
    assign jr   = (~o4 & ~o3 &  o2 & ~o1 & ~o0); // 00100 jr

    // bne?
    assign bne  = (~o4 & ~o3 & ~o2 &  o1 & ~o0); // 00010 bne

    // blt?
    assign blt  = (~o4 & ~o3 &  o2 &  o1 & ~o0); // 00110 blt

    // beq?
    assign beq  = ( o4 &  o3 & ~o2 & ~o1 &  o0); // 11001 beq

    // bbp?
    assign bbp  = ( o4 &  o3 & ~o2 & ~o1 & ~o0); // 11000 bbp

    // setx?
    assign setx = ( o4 & ~o3 &  o2 & ~o1 &  o0); // 10101 setx

    // bex?
    wire bex;
    assign bex  = ( o4 & ~o3 &  o2 &  o1 & ~o0); // 10110 bex

    // determine the actual target based on the instruction
    tristate32 tri_j   (target_actual, target32, j);
    tristate32 tri_jal (target_actual, target32, jal);
    tristate32 tri_jr  (target_actual, ALU_B,    jr);
    tristate32 tri_bne (target_actual, PCplusN,  bne);
    tristate32 tri_blt (target_actual, PCplusN,  blt);
    tristate32 tri_beq (target_actual, PCplusN,  beq);
    tristate32 tri_bbp (target_actual, PCplusN,  bbp);
    tristate32 tri_setx(target_actual, target32, setx);
    tristate32 tri_bex (target_actual, target32, bex);

    // determine if current instruction is a jump/branch that is taken
    wire jb1, jb2;  // split into 2 for fan-in reasons
    assign jb1 =    j |
                    jal |
                    jr |
                    bne & ne;
    assign jb2 =    blt & ~lt & ne | // lt checks if rs<rd but we need rd<rs ==> (rs!<rd & rs!=rd) ._.
                    beq & ~ne |
                    bbp & bval |
                    bex & (rstatus != 32'b0 | bypexcpt);  
    assign jb =     jb1 | jb2;
                

    // enable writing to graphics if instruction is ren
    assign ren = ( o4 &  o3 & ~o2 &  o1 & ~o0); // 11010 ren
    assign sprite = instr[11:0];

    // signal to quit
    assign quit_status[0] = ( o4 &  o3 &  o2 &  o1 &  o0); // 11111 QUITGAME
    assign quit_status[1] = quit_status[0] & ALU_B[0];    // reset regfile if QUITGAME and $rd = 1

    
endmodule