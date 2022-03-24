module mult_control(sum, Q, data_operandA);
    // inputs/outputs
    output [64:0] sum;
    input [64:0] Q;
    input [31:0] data_operandA;

    // create potential values to add to/subtract from current value:
    //      zeroes =    32-bit 0
    //      mltcnd =    multiplicand
    //      mltcn2 =    multiplicand * 2
    wire [31:0] zeroes, mltcnd, mltcn2;
    assign zeroes = 32'b00000000000000000000000000000000;
    assign mltcnd = data_operandA;
    assign mltcn2 = data_operandA <<< 1;

    // decide which of these to add/subtract.
    // note that Q[2] = 0 if addition is happening and 1 if subtraction
    // NOTE: if experiencing problems at higher clock rates, optimize this part. it's kinda inefficient.
    wire [31:0] addend, subtrahend, add_sub_end;
    mux8 addend_mux(addend, Q[2:0], zeroes, mltcnd, mltcnd, mltcn2, mltcn2, mltcnd, mltcnd, zeroes);
    not32 subtrahend_not(subtrahend, addend);
    mux2 add_sub_mux(add_sub_end, Q[2], addend, subtrahend);

    // do the addition/subtraction using the decided input.
    wire overflow;
    cla_32 adder(sum[64:33], overflow, Q[64:33], add_sub_end, Q[2]);
    assign sum[32:0] = Q[32:0];
endmodule