/**
 *   
 *  The CPU of the game console.
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB,                  // I: Data from port B of RegFile

    // Controller
    controller                      // I: Button press data for previous frame
	 
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

    // Controller
    input [7:0] controller;




    // -----------------------------------------------------------------------------------------------
    //                                          WIRE DECLARATIONS 
    // -----------------------------------------------------------------------------------------------

    // F stage ---------------------------------------------------------------------------------------
    wire [31:0] PC_in, PC_out, PC_plus1, PC_alt;                            // PC-related wires
    wire [31:0] INSTR_into_FD;                                              // FD latch inputs                                                      
    

    // D stage ---------------------------------------------------------------------------------------
    wire [31:0] PC_FD, INSTR_FD;                                            // FD latch outputs
    wire [4:0] rrA_D, rrB_D;                                                // registers to read
    wire [31:0] readRegA_into_DX, readRegA_into_DX_alt;                     // DX latch inputs
    

    // X stage ---------------------------------------------------------------------------------------
    wire [31:0] PC_DX, regoutA_DX, regoutB_DX, INSTR_DX;                    // DX latch outputs
    wire [31:0] imm32_X, target32_X, ALU_input_B_pre;                       // X 32-bit info
    wire [4:0] ALUop_X, shamt_X;                                            // X 5-bit control
    wire ALUinB_X, ctrl_MULT_X, ctrl_DIV_X, 
            jb_X, jal_X, setx_X, neq_X, lt_X;                               // X 1-bit control
    
    wire [1:0] ALUinA_bypass, ALUinB_bypass;                                // bypassing mux select bits
    wire MemData_bypass, MULTDIVinA_bypass, MULTDIVinB_bypass,
            ALUexcptA, ALUexcptB;                                           // bypassing info
    wire [31:0] exceptval_bypass;

    wire [31:0] ALU_input_A, ALU_input_A_0, ALU_input_B, ALU_input_B_pre_0; // ALU inputs
    wire [31:0] ALU_out_pre, ALU_out;                                       // ALU outputs

    wire [31:0] INSTR_into_XM;                                              // XM latch inputs


    // M stage ---------------------------------------------------------------------------------------
    wire [31:0] ALUout_XM, regoutB_XM;                                      // XM latch outputs
    wire MemWE_M;                                                           // M control
    wire [31:0] INSTR_into_MW, VALUE_into_MW;                               // MW latch inputs


    // C stage ---------------------------------------------------------------------------------------
    wire [31:0] regoutA_XC, regoutB_XC;                                     // XC latch outputs
    wire new_instr, ctrl_MULT_C, ctrl_DIV_C, md_rdy, en_XC;                 // C control
    wire [31:0] MULTDIVinA, MULTDIVinB, result_C;                           // multdiv inputs/outputs                       


    // W stage ---------------------------------------------------------------------------------------
    wire [31:0] ALUout_MW, memdata_MW, P_CW, INSTR_CW;                      // MW/CW latch outputs
    wire [31:0] WVal;                                                       // write value going to regfile
    wire RegWE_W, BVal;                                                     // W control
    wire [4:0] RegWDest_W;                                                  //      they're all of different lengths ._.
    wire [1:0] WrSrc_W;                                                     //      so we need 3 lines for 4 wires


    // instructions ----------------------------------------------------------------------------------
    wire [31:0] INSTR_into_DX, INSTR_into_DX_alt;                           // wire inputs to specified latch
    wire [31:0] INSTR_XM, INSTR_MW, INSTR_XC;                               // wire outputs from specified latch


    // control signals -------------------------------------------------------------------------------
    wire multdiving;                                                        // are we multiplying/dividing?
    wire toALU_stall;                                                       // stall condition                     


    // exceptions ------------------------------------------------------------------------------------
    wire [31:0] excpt_val;                                                  // actual value to be written to $rstatus
    wire EXCEPTION, excpt_XM, excpt_MW, excpt_CW, md_excpt;                 // exception conditions


    // waste wires -----------------------------------------------------------------------------------
    wire PC_adder_of, ov_X;                                                 // unused overflow wires





    // --------------------------------------------------------------------------------------------------------------------------
    // |                                                                                                                        |
    // |                                                                                                                        |
    // |                                                pipeline time!                                                          |
    // |                                                                                                                        |
    // |                                                                                                                        |
    // --------------------------------------------------------------------------------------------------------------------------




    // --------------------------------------------------------------------------------------------------------------------------
    // |                                                                                                                        |
                PC_latch PC(PC_out,
                            PC_in,
                            ~clock, (~multdiving & ~toALU_stall & ~EXCEPTION), reset);                                   
    // |                                                                                                                        |
    // --------------------------------------------------------------------------------------------------------------------------

    // increment and assign PC
    cla_32 PC_adder(PC_plus1, PC_adder_of, PC_out, 32'b1, 1'b0);
    assign PC_in = jb_X ? PC_alt : PC_plus1; 
    assign address_imem = PC_out;

    // insert either the current instruction or nop into FD
    assign INSTR_into_FD = jb_X ? 32'b0 : q_imem;

    // stall condition
    stall stalling(toALU_stall, INSTR_FD, INSTR_DX);
    


    // --------------------------------------------------------------------------------------------------------------------------
    // |                                                                                                                        |
                FD_latch FD(PC_FD,  INSTR_FD,
                            PC_out, INSTR_into_FD,
                            ~clock, ~multdiving & ~toALU_stall & ~EXCEPTION, reset);                                     
    // |                                                                                                                        |
    // --------------------------------------------------------------------------------------------------------------------------

    // control
    D_control d_ctrl(rrA_D, rrB_D, INSTR_FD);


    // assign the regfile wires

    assign data_writeReg    = WVal;         // \
    assign ctrl_writeEnable = RegWE_W;      //  }- from writeback
    assign ctrl_writeReg    = RegWDest_W;   // /
    assign ctrl_readRegA    = rrA_D;
    assign ctrl_readRegB    = rrB_D;
    


    assign INSTR_into_DX_alt = jal_X ? {5'b0, 5'b11111, 22'b0} : 32'b0; // if jal-ing, put add $31, $0, $0 (but override $rs value) 
    assign INSTR_into_DX = toALU_stall|jb_X ? INSTR_into_DX_alt : INSTR_FD;

    assign readRegA_into_DX_alt = PC_FD; // current PC+1
    assign readRegA_into_DX = jal_X ? readRegA_into_DX_alt : data_readRegA; 
    

    // --------------------------------------------------------------------------------------------------------------------------
    // |                                                                                                                        |
                DX_latch DX(PC_DX, regoutA_DX, regoutB_DX, INSTR_DX,
                            PC_FD, readRegA_into_DX, data_readRegB, INSTR_into_DX,
                            ~clock, (~multdiving & ~EXCEPTION), reset);                                    
    // |                                                                                                                        |
    // --------------------------------------------------------------------------------------------------------------------------

    // control
    X_control x_ctrl(ALUinB_X, imm32_X, ALUop_X, shamt_X, ctrl_MULT_X, ctrl_DIV_X, jb_X, PC_alt, jal_X, setx_X, 
                        INSTR_DX, PC_DX, ALU_input_B_pre, neq_X, lt_X, ALU_input_B_pre, (excpt_XM | excpt_MW | excpt_CW | md_excpt));

    // bypassing 
    bypass byp(ALUinA_bypass, ALUinB_bypass, MemData_bypass, MULTDIVinA_bypass, MULTDIVinB_bypass, ALUexcptA, ALUexcptB, exceptval_bypass,
                INSTR_DX, INSTR_XM, INSTR_MW, INSTR_XC, excpt_XM);

    // ALU inputs
    mux4 ALUinAmux(ALU_input_A_0,     ALUinA_bypass, regoutA_DX, WVal, ALUout_XM, ALUout_XM);
    tristate32 ALUnA(ALU_input_A, ALU_input_A_0,    ~ALUexcptA);
    tristate32 ALUeA(ALU_input_A, exceptval_bypass,  ALUexcptA);

    mux4 ALUinBmux(ALU_input_B_pre_0, ALUinB_bypass, regoutB_DX, WVal, ALUout_XM, ALUout_XM);
    tristate32 ALUnB(ALU_input_B_pre, ALU_input_B_pre_0, ~ALUexcptB);
    tristate32 ALUeB(ALU_input_B_pre, exceptval_bypass,   ALUexcptB);
    
    assign ALU_input_B = ALUinB_X ? imm32_X : ALU_input_B_pre;

    // do the ALU
    alu arlog(ALU_input_A, ALU_input_B, ALUop_X, shamt_X, ALU_out_pre, neq_X, lt_X, ov_X);
    assign ALU_out = setx_X ? PC_alt : ALU_out_pre; // PC_alt is the 32-bit target - for setx, doesn't actually correspond to PC

    assign INSTR_into_XM = jb_X & ~jal_X ? 32'b0 : INSTR_DX;


    // --------------------------------------------------------------------------------------------------------------------------
    // |                                                                                                                        |
                XM_latch XM(ALUout_XM, regoutB_XM, INSTR_XM, excpt_XM,
                            ALU_out, ALU_input_B_pre, INSTR_into_XM, ov_X,
                            ~clock, (~multdiving & ~EXCEPTION), reset);                                    
    // |                                                                                                                        |
    // --------------------------------------------------------------------------------------------------------------------------

    // control
    M_control m_ctrl(MemWE_M, INSTR_XM);

    // hook up to data memory
    assign address_dmem = ALUout_XM;
    assign data = MemData_bypass ? WVal : regoutB_XM;
    assign wren = MemWE_M;

    // insert setx on exception
    assign INSTR_into_MW = EXCEPTION ? {5'b10101, excpt_val[26:0]} : INSTR_XM;
    assign VALUE_into_MW = EXCEPTION ? excpt_val : ALUout_XM;


    // --------------------------------------------------------------------------------------------------------------------------
    // |                                                                                                                        |
                MW_latch MW(ALUout_MW, memdata_MW, INSTR_MW, excpt_MW,
                            VALUE_into_MW, q_dmem, INSTR_into_MW, excpt_XM,
                            ~clock, ~multdiving, reset); // update when not doing a multicycle operation                                     
    // |                                                                                                                        |
    // --------------------------------------------------------------------------------------------------------------------------
    
    // control
    W_control w_ctrl(RegWE_W, RegWDest_W, WrSrc_W, BVal, INSTR_MW, controller);

    // writeback value
    // select bits: source
    //      00: ALU output
    //      01: multdiv output
    //      10: memory data
    //      11: controller data
    mux4 wval(WVal, WrSrc_W, ALUout_MW, P_CW, memdata_MW, {31'b0, BVal});
    

    // --------------------------------------------------------------------------------------------------------------------------
    // |                                                                                                                        |
                XC_latch XC(regoutA_XC,  regoutB_XC,      INSTR_XC,
                            ALU_input_A, ALU_input_B_pre, INSTR_DX,
                            ~clock, (en_XC & ~EXCEPTION), reset); // update XC latch if mult, div, or data_ready                                    
    // |                                                                                                                        |
    // --------------------------------------------------------------------------------------------------------------------------
    
    // dffe that keeps track of whether on the last instruction we got a new instruction
    dffe_ref Y(new_instr, en_XC, ~clock, 1'b1, reset);

    // control
    C_control c_ctrl(ctrl_MULT_C, ctrl_DIV_C, multdiving, en_XC, INSTR_XC, new_instr, md_rdy);

    // assign multdiv inputs
    assign MULTDIVinA = MULTDIVinA_bypass ? WVal : regoutA_XC;
    assign MULTDIVinB = MULTDIVinB_bypass ? WVal : regoutB_XC; 
    
    // multdiv
    multdiv md(MULTDIVinA, MULTDIVinB, ctrl_MULT_C, ctrl_DIV_C, clock, result_C, md_excpt, md_rdy);


    // --------------------------------------------------------------------------------------------------------------------------
    // |                                                                                                                        |
                CW_latch CW(P_CW, INSTR_CW, excpt_CW,
                            result_C, INSTR_XC, md_excpt,
                            ~clock, md_rdy, reset); // update CW latch if data_ready                                    
    // |                                                                                                                        |
    // --------------------------------------------------------------------------------------------------------------------------

    // handle exceptions
    or excptor(EXCEPTION, excpt_MW, (excpt_CW & WrSrc_W[0])); // only consider multdiv exceptions if you're reading the multdiv value
    exception excptval(excpt_val, excpt_MW|excpt_CW, INSTR_MW);
    

endmodule
