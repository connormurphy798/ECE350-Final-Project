module multiplier(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;


    // select what the input to the 65-bit register is:
    //      if in a cycle (ctrl_MULT = 0), input is the previous sum >>>2
    //      if entering a new cycle (ctrl_MULT = 1), input is 32 zeroes, the multiplier, then an extra 0

    wire [64:0] PMreg65_D, new_PMreg65_D, shifted_sum;
    assign new_PMreg65_D[0] = 1'b0;
    assign new_PMreg65_D[32:1] = data_operandB;
    assign new_PMreg65_D[64:33] = 32'b00000000000000000000000000000000;
    assign PMreg65_D = ctrl_MULT ? new_PMreg65_D : shifted_sum;


    // create PMreg65 register module and assign data_result.
    //  [0]     =   extra bit
    //  [32:1]  =   multiplier (data_operandB)
    //  [64:33] =   running total
    wire [64:0] PMreg65_Q;
    reg65b PMreg65(PMreg65_Q, PMreg65_D, clock, clock, 1'b0);
    assign data_result = PMreg65_Q[32:1];

    // pipe the current Q value into the partial product control box
    wire [64:0] sum;
    mult_control ppcontrol(sum, PMreg65_Q, data_operandA);

    // arithmetic shift that result to the right by 2
    rshift2_65 shifter(shifted_sum, sum, 1'b1);


    // 32-bit register holds info on the number of steps performed.
    // here we need 16 steps to complete a multiply, so we:
    //      - initialize counter at 0
    //      - increment it once every clock cycle
    //      - mark the data as ready when we reach 16
    wire [31:0] countreg32_D, countreg32_Q, one;
    wire of0, counter_reset, multiplying;
    assign one = 32'b00000000000000000000000000000001;

    assign counter_reset = ctrl_MULT;
    cla_32 add1(countreg32_D, of0, countreg32_Q, one, 1'b0);
    dffe_ref multing(multiplying, ctrl_MULT, clock, ctrl_MULT|ctrl_DIV, 1'b0); // enable counter only if multiplying
    reg32b countreg32(countreg32_Q, countreg32_D, clock, multiplying, counter_reset);

    and data_ready(data_resultRDY, ~countreg32_Q[0], ~countreg32_Q[1], ~countreg32_Q[2], ~countreg32_Q[3], countreg32_Q[4]);


    // exceptions!

    // check if bits [64:32] of PMreg65_Q are all 1
    wire top_neg, top_neg3, top_neg2, top_neg1, top_neg0;
    and tn3(top_neg3, PMreg65_Q[64], PMreg65_Q[63], PMreg65_Q[62], PMreg65_Q[61], PMreg65_Q[60], PMreg65_Q[59], PMreg65_Q[58], PMreg65_Q[57]);
    and tn2(top_neg2, PMreg65_Q[56], PMreg65_Q[55], PMreg65_Q[54], PMreg65_Q[53], PMreg65_Q[52], PMreg65_Q[51], PMreg65_Q[50], PMreg65_Q[49]);
    and tn1(top_neg1, PMreg65_Q[48], PMreg65_Q[47], PMreg65_Q[46], PMreg65_Q[45], PMreg65_Q[44], PMreg65_Q[43], PMreg65_Q[42], PMreg65_Q[41]);
    and tn0(top_neg0, PMreg65_Q[40], PMreg65_Q[39], PMreg65_Q[38], PMreg65_Q[37], PMreg65_Q[36], PMreg65_Q[35], PMreg65_Q[34], PMreg65_Q[33]);
    and tn(top_neg, top_neg3, top_neg2, top_neg1, top_neg0, PMreg65_Q[32]);

    // check if bits [64:32] of PMreg65_Q are all 0
    wire top_pos, top_pos3, top_pos2, top_pos1, top_pos0;
    nor tp3(top_pos3, PMreg65_Q[64], PMreg65_Q[63], PMreg65_Q[62], PMreg65_Q[61], PMreg65_Q[60], PMreg65_Q[59], PMreg65_Q[58], PMreg65_Q[57]);
    nor tp2(top_pos2, PMreg65_Q[56], PMreg65_Q[55], PMreg65_Q[54], PMreg65_Q[53], PMreg65_Q[52], PMreg65_Q[51], PMreg65_Q[50], PMreg65_Q[49]);
    nor tp1(top_pos1, PMreg65_Q[48], PMreg65_Q[47], PMreg65_Q[46], PMreg65_Q[45], PMreg65_Q[44], PMreg65_Q[43], PMreg65_Q[42], PMreg65_Q[41]);
    nor tp0(top_pos0, PMreg65_Q[40], PMreg65_Q[39], PMreg65_Q[38], PMreg65_Q[37], PMreg65_Q[36], PMreg65_Q[35], PMreg65_Q[34], PMreg65_Q[33]);
    and tp(top_pos, top_pos3, top_pos2, top_pos1, top_pos0, ~PMreg65_Q[32]);

    // put those results together and find out if there's an exception
    wire bad_signs;
    wire bad_top;

    and signs(bad_signs, data_operandA[31], data_operandB[31], data_result[31]); // problem multiplying by -2^31
    nor top(bad_top, top_neg, top_pos);
    or exception(data_exception, bad_signs, bad_top);

endmodule