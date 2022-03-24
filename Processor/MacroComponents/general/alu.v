module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;

    // add your code here:

    // take the not of B - needed for subtraction
    wire [31:0] notB;
    not32 not_B(notB, data_operandB);

    // ----------------------------------------------- MAIN OPERATIONS -----------------------------------------------

    // and + or
    wire [31:0] A_and_B, A_or_B;
    and32 AandB(A_and_B, data_operandA, data_operandB);
    or32 AorB(A_or_B, data_operandA, data_operandB);
    
    
    // lshift + rshift
    wire [31:0] A_lshift, A_rshift;
    lshift_32 Alshift(A_lshift, data_operandA, ctrl_shiftamt);
    rshift_32 Arshift(A_rshift, data_operandA, ctrl_shiftamt);

    // add + sub
    wire [31:0] A_plus_B, A_minus_B;
    wire add_overflow, sub_overflow;
    cla_32 add(A_plus_B, add_overflow, data_operandA, data_operandB, 1'b0);
    cla_32 sub(A_minus_B, sub_overflow, data_operandA, notB, 1'b1);


    // all operations computed every time, so we need to mux them using the opcode to get the desired output
    wire [31:0] zero32;
    wire [31:0] result;
    assign zero32 = 32'b00000000000000000000000000000000;
    mux8 data_out_mux(result, ctrl_ALUopcode[2:0], A_plus_B, A_minus_B, A_and_B, A_or_B, A_lshift, A_rshift, zero32, zero32);
    // but if there's an overflow, just output 0. for some reason
    tristate32 ov0(data_result, result, ~overflow);
    tristate32 ov1(data_result, zero32,  overflow);





    // ----------------------------------------------- INFO SIGNALS -----------------------------------------------


    // overflow handling
    // but wait, we're doing both addition and subtraction! we need to get the overflow state of whichever one we reported
    mux2_1 overflow_mux(overflow, ctrl_ALUopcode[0], add_overflow, sub_overflow);


    // not equal
    wire sub_not_zero_0, sub_not_zero_1, sub_not_zero_2, sub_not_zero_3;
    // if any of the wires on the subtraction result are a 1, A and B are not equal!
    or sub00(sub_not_zero_0,    A_minus_B[7], A_minus_B[6],
                                A_minus_B[5], A_minus_B[4],
                                A_minus_B[3], A_minus_B[2],
                                A_minus_B[1], A_minus_B[0]);

    or sub01(sub_not_zero_1,    A_minus_B[15], A_minus_B[14],
                                A_minus_B[13], A_minus_B[12],
                                A_minus_B[11], A_minus_B[10],
                                A_minus_B[9], A_minus_B[8]);

    or sub02(sub_not_zero_2,    A_minus_B[23], A_minus_B[22],
                                A_minus_B[21], A_minus_B[20],
                                A_minus_B[19], A_minus_B[18],
                                A_minus_B[17], A_minus_B[16]);

    or sub03(sub_not_zero_3,    A_minus_B[31], A_minus_B[30],
                                A_minus_B[29], A_minus_B[28],
                                A_minus_B[27], A_minus_B[26],
                                A_minus_B[25], A_minus_B[24]);
    or sub0(isNotEqual, sub_not_zero_0, sub_not_zero_1, sub_not_zero_2, sub_not_zero_3);



    // less than
    wire lt, nlt;
    // A < B if A - B is negative...
    assign lt = A_minus_B[31];
    not not_lt(nlt, lt);
    // ...unless there's overflow, in which case we invert the result
    mux2_1 less_than_mux(isLessThan, overflow, lt, nlt);
endmodule