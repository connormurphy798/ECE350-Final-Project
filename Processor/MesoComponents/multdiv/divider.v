module divider(data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;


    // check if either of the operands are negative
    wire dvnd_isneg, dvsr_isneg;
    assign dvnd_isneg = data_operandA[31];
    assign dvsr_isneg = data_operandB[31];

    // get abs(dvnd)
    wire [31:0] abs_dvnd, dvnd_adder_in;
    wire dvnd_of;
    //assign dvnd_adder_in = dvnd_isneg ? ~(data_operandA) : data_operandA; // turned this into tristates for efficiency
    tristate32 dvnd_adder_in0(dvnd_adder_in, ~(data_operandA), dvnd_isneg);
    tristate32 dvnd_adder_in1(dvnd_adder_in, data_operandA, ~(dvnd_isneg));
    cla_32 dvnd_adder(abs_dvnd, dvnd_of, 32'b0, dvnd_adder_in, dvnd_isneg);

    // get abs(dvsr)
    wire [31:0] abs_dvsr, dvsr_adder_in;
    wire dvsr_of;
    //assign dvsr_adder_in = dvsr_isneg ? ~(data_operandB) : data_operandB; // turned this into tristates for efficiency
    tristate32 dvsr_adder_in0(dvsr_adder_in, ~(data_operandB), dvsr_isneg);
    tristate32 dvsr_adder_in1(dvsr_adder_in, data_operandB, ~(dvsr_isneg));
    cla_32 dvsr_adder(abs_dvsr, dvsr_of, 32'b0, dvsr_adder_in, dvsr_isneg);



    // start the loop!

    // select what the input to the 64-bit register is:
    //      if in a cycle (ctrl_DIV = 0), input is the previous sum
    //      if entering a new cycle (ctrl_DIV = 1), input is 32 zeroes then abs(dividend)

    wire [63:0] AQreg64_D, new_AQreg64_D, prev_sum;
    assign new_AQreg64_D[31:0] = abs_dvnd;
    assign new_AQreg64_D[63:32] = 32'b0;
    assign AQreg64_D = ctrl_DIV ? new_AQreg64_D : prev_sum;


    // create AQreg64 register module.
    //  [31:0]  =   dividend (data_operandA)
    //  [63:32] =   remainder
    wire [63:0] AQreg64_Q, to_shift;
    wire [31:0] pre_data_result;
    reg64b AQreg64(AQreg64_Q, AQreg64_D, clock, clock, 1'b0);


    // shift the register's output and assign the result of the division
    wire [63:0] shifted;
    assign shifted[63:1] =  AQreg64_Q[62:0];
    assign shifted[0]    = ~AQreg64_Q[63];
    assign pre_data_result[31:0] = shifted[31:0];


    // do the add/subtract
    wire [31:0] top_sum, adder_b;
    wire adder_of;
    assign adder_b = shifted[63] ? abs_dvsr : ~(abs_dvsr);
    cla_32 addsub_dvsr(top_sum, adder_of, shifted[63:32], adder_b, ~shifted[63]);

    // assign the previous sum
    assign prev_sum[31:0]  = shifted[31:0];
    assign prev_sum[63:32] = top_sum[31:0];




    // negate data_result if data_opA and data_opB have different signs
    wire negate, final_of;
    xor neg(negate, dvsr_isneg, dvnd_isneg);

    wire [31:0] final_adder_b;
    tristate32 pre_yes(final_adder_b, pre_data_result, ~(negate));
    tristate32 pre_not(final_adder_b, ~(pre_data_result), negate);

    cla_32 final_adder(data_result, final_of, 32'b0, final_adder_b, negate);







    // 32-bit register holds info on the number of steps performed.
    // here we need 32 steps to complete a divide, so we:
    //      - initialize counter at 0
    //      - increment it once every clock cycle
    //      - mark the data as ready when we reach 32
    wire [31:0] countreg32_D, countreg32_Q, one;
    wire of0, counter_reset, dividing;
    assign one = 32'b00000000000000000000000000000001;

    assign counter_reset = ctrl_DIV;
    cla_32 add1(countreg32_D, of0, countreg32_Q, one, 1'b0);
    dffe_ref diving(dividing, ctrl_DIV, clock, ctrl_MULT|ctrl_DIV, 1'b0); // enable counter only if dividing
    reg32b countreg32(countreg32_Q, countreg32_D, clock, dividing, counter_reset);

    and data_ready(data_resultRDY, ~countreg32_Q[0], ~countreg32_Q[1], ~countreg32_Q[2], ~countreg32_Q[3], ~countreg32_Q[4], countreg32_Q[5]);


    // exception if dividing by 0
    wire divzero_0, divzero_1, divzero_2, divzero_3;
    nor dz0(divzero_0, data_operandB[31], data_operandB[30], data_operandB[29], data_operandB[28], data_operandB[27], data_operandB[26], data_operandB[25], data_operandB[24]);
    nor dz1(divzero_1, data_operandB[23], data_operandB[22], data_operandB[21], data_operandB[20], data_operandB[19], data_operandB[18], data_operandB[17], data_operandB[16]);
    nor dz2(divzero_2, data_operandB[15], data_operandB[14], data_operandB[13], data_operandB[12], data_operandB[11], data_operandB[10], data_operandB[9],  data_operandB[8]);
    nor dz3(divzero_3, data_operandB[7],  data_operandB[6],  data_operandB[5],  data_operandB[4],  data_operandB[3],  data_operandB[2],  data_operandB[1],  data_operandB[0]);
    and exception(data_exception, divzero_0, divzero_1, divzero_2, divzero_3);

endmodule