module multdiv(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;


    // did we last get a signal to multiply, to divide, or neither?
    wire multiplying, dividing, neither;
    dffe_ref multing(multiplying, ctrl_MULT, clock, ctrl_MULT|ctrl_DIV|data_resultRDY, 1'b0);
    dffe_ref diving (dividing,    ctrl_DIV,  clock, ctrl_MULT|ctrl_DIV|data_resultRDY, 1'b0);
    nor nope(neither, multiplying, dividing);



    // ----------------------------------------------------------------------------------
    // |                                                                                |
    // |                                MULTIPLIER                                      |
    // |                                                                                |
    // ----------------------------------------------------------------------------------

    // set up the multiplier
    wire [31:0] mult_result;
    wire mult_exception, mult_ready;
    multiplier mult(data_operandA, data_operandB, ctrl_MULT, ctrl_DIV, clock, mult_result, mult_exception, mult_ready);
    
    // connect its output to the multdiv output via tristates
    tristate32 mult_res(data_result,    mult_result,    multiplying);
    tristate01 mult_exp(data_exception, mult_exception, multiplying);
    tristate01 mult_rdy(data_resultRDY, mult_ready,     multiplying);



    // ----------------------------------------------------------------------------------
    // |                                                                                |
    // |                                  DIVIDER                                       |
    // |                                                                                |
    // ----------------------------------------------------------------------------------

    // set up the divider
    wire [31:0] div_result;
    wire div_exception, div_ready;
    divider div(data_operandA, data_operandB, ctrl_MULT, ctrl_DIV, clock, div_result, div_exception, div_ready);

    // connect its output to the multdiv output via tristates
    tristate32 dvde_res(data_result,    div_result,    dividing);
    tristate01 dvde_exp(data_exception, div_exception, dividing);
    tristate01 dvde_rdy(data_resultRDY, div_ready,     dividing);


    // ------------------------------ cleanup -------------------------------------

    // doing neither? hook up zeroes to those outputs, babey!
    tristate32 none_res(data_result,    32'b0, neither);
    tristate01 none_exp(data_exception,  1'b0, neither);
    tristate01 none_rdy(data_resultRDY,  1'b0, neither);
    
endmodule