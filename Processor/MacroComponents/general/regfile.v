module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, ctrl_readRegC, data_writeReg,
	data_readRegA, data_readRegB, data_readRegC,
    data_rtest1, data_rtest2
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB, ctrl_readRegC;
	input [31:0] data_writeReg;

	output [31:0] data_readRegA, data_readRegB, data_readRegC;
    output data_rtest1, data_rtest2;


	// decode readRegA, readRegB, readRegC, and writeReg inputs
	wire [31:0] readR_A, readR_B, readR_C, writeR;
	
	dec_5to32 decRA(readR_A, ctrl_readRegA);
	dec_5to32 decRB(readR_B, ctrl_readRegB);
	dec_5to32 decRC(readR_C, ctrl_readRegC);
	dec_5to32 decW (writeR,  ctrl_writeReg);


	// make a 32-bit write enable wire writeR_X that follows the following rules:
	//		- if ctrl_writeReg, it's all zeroes except for its Xth index, where X is the number of the write register
	//		- if not ctrl_writeReg, it's all zeroes 
	wire [31:0] writeR_X, zeroes32, ones32, zeroes_or_ones;
	assign zeroes32 = 32'b00000000000000000000000000000000;
	assign ones32   = 32'b11111111111111111111111111111111;

	mux2 zero_or_one_mux(zeroes_or_ones, ctrl_writeEnable, zeroes32, ones32);
	and32 writeR_X_and(writeR_X, writeR, zeroes_or_ones);




	//
	// create the individual register modules and hook up their inputs/outputs
	//

	// qXX wires contain the output of register XX
	wire [31:0] q00, q01, q02, q03, q04, q05, q06, q07, q08, q09, q10, q11, q12, q13, q14, q15;
	wire [31:0] q16, q17, q18, q19, q20, q21, q22, q23, q24, q25, q26, q27, q28, q29, q30, q31;

	// registers, noting that reg0 is a special case with input always 0
	reg32b reg00(q00, zeroes32,      clock, writeR_X[0],  ctrl_reset);
	reg32b reg01(q01, data_writeReg, clock, writeR_X[1],  ctrl_reset);
	reg32b reg02(q02, data_writeReg, clock, writeR_X[2],  ctrl_reset);
	reg32b reg03(q03, data_writeReg, clock, writeR_X[3],  ctrl_reset);
	reg32b reg04(q04, data_writeReg, clock, writeR_X[4],  ctrl_reset);
	reg32b reg05(q05, data_writeReg, clock, writeR_X[5],  ctrl_reset);
	reg32b reg06(q06, data_writeReg, clock, writeR_X[6],  ctrl_reset);
	reg32b reg07(q07, data_writeReg, clock, writeR_X[7],  ctrl_reset);
	reg32b reg08(q08, data_writeReg, clock, writeR_X[8],  ctrl_reset);
	reg32b reg09(q09, data_writeReg, clock, writeR_X[9],  ctrl_reset);
	reg32b reg10(q10, data_writeReg, clock, writeR_X[10], ctrl_reset);
	reg32b reg11(q11, data_writeReg, clock, writeR_X[11], ctrl_reset);
	reg32b reg12(q12, data_writeReg, clock, writeR_X[12], ctrl_reset);
	reg32b reg13(q13, data_writeReg, clock, writeR_X[13], ctrl_reset);
	reg32b reg14(q14, data_writeReg, clock, writeR_X[14], ctrl_reset);
	reg32b reg15(q15, data_writeReg, clock, writeR_X[15], ctrl_reset);
	reg32b reg16(q16, data_writeReg, clock, writeR_X[16], ctrl_reset);
	reg32b reg17(q17, data_writeReg, clock, writeR_X[17], ctrl_reset);
	reg32b reg18(q18, data_writeReg, clock, writeR_X[18], ctrl_reset);
	reg32b reg19(q19, data_writeReg, clock, writeR_X[19], ctrl_reset);
	reg32b reg20(q20, data_writeReg, clock, writeR_X[20], ctrl_reset);
	reg32b reg21(q21, data_writeReg, clock, writeR_X[21], ctrl_reset);
	reg32b reg22(q22, data_writeReg, clock, writeR_X[22], ctrl_reset);
	reg32b reg23(q23, data_writeReg, clock, writeR_X[23], ctrl_reset);
	reg32b reg24(q24, data_writeReg, clock, writeR_X[24], ctrl_reset);
	reg32b reg25(q25, data_writeReg, clock, writeR_X[25], ctrl_reset);
	reg32b reg26(q26, data_writeReg, clock, writeR_X[26], ctrl_reset);
	reg32b reg27(q27, data_writeReg, clock, writeR_X[27], ctrl_reset);
	reg32b reg28(q28, data_writeReg, clock, writeR_X[28], ctrl_reset);
	reg32b reg29(q29, data_writeReg, clock, writeR_X[29], ctrl_reset);
	reg32b reg30(q30, data_writeReg, clock, writeR_X[30], ctrl_reset);
	reg32b reg31(q31, data_writeReg, clock, writeR_X[31], ctrl_reset);


	//
	// so many potential outputs! let's pick which ones we're supposed to actually go with
	//

	// first is regA
	tristate32 q00triA(data_readRegA, q00, readR_A[0]);
	tristate32 q01triA(data_readRegA, q01, readR_A[1]);
	tristate32 q02triA(data_readRegA, q02, readR_A[2]);
	tristate32 q03triA(data_readRegA, q03, readR_A[3]);
	tristate32 q04triA(data_readRegA, q04, readR_A[4]);
	tristate32 q05triA(data_readRegA, q05, readR_A[5]);
	tristate32 q06triA(data_readRegA, q06, readR_A[6]);
	tristate32 q07triA(data_readRegA, q07, readR_A[7]);
	tristate32 q08triA(data_readRegA, q08, readR_A[8]);
	tristate32 q09triA(data_readRegA, q09, readR_A[9]);
	tristate32 q10triA(data_readRegA, q10, readR_A[10]);
	tristate32 q11triA(data_readRegA, q11, readR_A[11]);
	tristate32 q12triA(data_readRegA, q12, readR_A[12]);
	tristate32 q13triA(data_readRegA, q13, readR_A[13]);
	tristate32 q14triA(data_readRegA, q14, readR_A[14]);
	tristate32 q15triA(data_readRegA, q15, readR_A[15]);
	tristate32 q16triA(data_readRegA, q16, readR_A[16]);
	tristate32 q17triA(data_readRegA, q17, readR_A[17]);
	tristate32 q18triA(data_readRegA, q18, readR_A[18]);
	tristate32 q19triA(data_readRegA, q19, readR_A[19]);
	tristate32 q20triA(data_readRegA, q20, readR_A[20]);
	tristate32 q21triA(data_readRegA, q21, readR_A[21]);
	tristate32 q22triA(data_readRegA, q22, readR_A[22]);
	tristate32 q23triA(data_readRegA, q23, readR_A[23]);
	tristate32 q24triA(data_readRegA, q24, readR_A[24]);
	tristate32 q25triA(data_readRegA, q25, readR_A[25]);
	tristate32 q26triA(data_readRegA, q26, readR_A[26]);
	tristate32 q27triA(data_readRegA, q27, readR_A[27]);
	tristate32 q28triA(data_readRegA, q28, readR_A[28]);
	tristate32 q29triA(data_readRegA, q29, readR_A[29]);
	tristate32 q30triA(data_readRegA, q30, readR_A[30]);
	tristate32 q31triA(data_readRegA, q31, readR_A[31]);

	// then regB
	tristate32 q00triB(data_readRegB, q00, readR_B[0]);
	tristate32 q01triB(data_readRegB, q01, readR_B[1]);
	tristate32 q02triB(data_readRegB, q02, readR_B[2]);
	tristate32 q03triB(data_readRegB, q03, readR_B[3]);
	tristate32 q04triB(data_readRegB, q04, readR_B[4]);
	tristate32 q05triB(data_readRegB, q05, readR_B[5]);
	tristate32 q06triB(data_readRegB, q06, readR_B[6]);
	tristate32 q07triB(data_readRegB, q07, readR_B[7]);
	tristate32 q08triB(data_readRegB, q08, readR_B[8]);
	tristate32 q09triB(data_readRegB, q09, readR_B[9]);
	tristate32 q10triB(data_readRegB, q10, readR_B[10]);
	tristate32 q11triB(data_readRegB, q11, readR_B[11]);
	tristate32 q12triB(data_readRegB, q12, readR_B[12]);
	tristate32 q13triB(data_readRegB, q13, readR_B[13]);
	tristate32 q14triB(data_readRegB, q14, readR_B[14]);
	tristate32 q15triB(data_readRegB, q15, readR_B[15]);
	tristate32 q16triB(data_readRegB, q16, readR_B[16]);
	tristate32 q17triB(data_readRegB, q17, readR_B[17]);
	tristate32 q18triB(data_readRegB, q18, readR_B[18]);
	tristate32 q19triB(data_readRegB, q19, readR_B[19]);
	tristate32 q20triB(data_readRegB, q20, readR_B[20]);
	tristate32 q21triB(data_readRegB, q21, readR_B[21]);
	tristate32 q22triB(data_readRegB, q22, readR_B[22]);
	tristate32 q23triB(data_readRegB, q23, readR_B[23]);
	tristate32 q24triB(data_readRegB, q24, readR_B[24]);
	tristate32 q25triB(data_readRegB, q25, readR_B[25]);
	tristate32 q26triB(data_readRegB, q26, readR_B[26]);
	tristate32 q27triB(data_readRegB, q27, readR_B[27]);
	tristate32 q28triB(data_readRegB, q28, readR_B[28]);
	tristate32 q29triB(data_readRegB, q29, readR_B[29]);
	tristate32 q30triB(data_readRegB, q30, readR_B[30]);
	tristate32 q31triB(data_readRegB, q31, readR_B[31]);

	// and finally regC!
	tristate32 q00triC(data_readRegC, q00, readR_C[0]);
	tristate32 q01triC(data_readRegC, q01, readR_C[1]);
	tristate32 q02triC(data_readRegC, q02, readR_C[2]);
	tristate32 q03triC(data_readRegC, q03, readR_C[3]);
	tristate32 q04triC(data_readRegC, q04, readR_C[4]);
	tristate32 q05triC(data_readRegC, q05, readR_C[5]);
	tristate32 q06triC(data_readRegC, q06, readR_C[6]);
	tristate32 q07triC(data_readRegC, q07, readR_C[7]);
	tristate32 q08triC(data_readRegC, q08, readR_C[8]);
	tristate32 q09triC(data_readRegC, q09, readR_C[9]);
	tristate32 q10triC(data_readRegC, q10, readR_C[10]);
	tristate32 q11triC(data_readRegC, q11, readR_C[11]);
	tristate32 q12triC(data_readRegC, q12, readR_C[12]);
	tristate32 q13triC(data_readRegC, q13, readR_C[13]);
	tristate32 q14triC(data_readRegC, q14, readR_C[14]);
	tristate32 q15triC(data_readRegC, q15, readR_C[15]);
	tristate32 q16triC(data_readRegC, q16, readR_C[16]);
	tristate32 q17triC(data_readRegC, q17, readR_C[17]);
	tristate32 q18triC(data_readRegC, q18, readR_C[18]);
	tristate32 q19triC(data_readRegC, q19, readR_C[19]);
	tristate32 q20triC(data_readRegC, q20, readR_C[20]);
	tristate32 q21triC(data_readRegC, q21, readR_C[21]);
	tristate32 q22triC(data_readRegC, q22, readR_C[22]);
	tristate32 q23triC(data_readRegC, q23, readR_C[23]);
	tristate32 q24triC(data_readRegC, q24, readR_C[24]);
	tristate32 q25triC(data_readRegC, q25, readR_C[25]);
	tristate32 q26triC(data_readRegC, q26, readR_C[26]);
	tristate32 q27triC(data_readRegC, q27, readR_C[27]);
	tristate32 q28triC(data_readRegC, q28, readR_C[28]);
	tristate32 q29triC(data_readRegC, q29, readR_C[29]);
	tristate32 q30triC(data_readRegC, q30, readR_C[30]);
	tristate32 q31triC(data_readRegC, q31, readR_C[31]);



    // test registers: always read the first bit of $r17 + $r18
    assign data_rtest1 = q17[0];
    assign data_rtest2 = q18[0];


endmodule
