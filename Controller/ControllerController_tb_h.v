/**
 *
 *  Wrapper for testing the controller interface on the FPGA.
 *
 **/

 module ControllerController_tb_h(
    // Outputs
    button_status,  // what buttons did we detect as pressed?

    // Inputs
    buttons_in       // what buttons were actually pressed?
    );

    input [7:0] buttons_in;

    output [7:0] button_status;

    // controller output to console - notted for testing purposes
    wire pin0, pin1, pin2, pin3, pin5, pin6, pin8;
    assign pin0 = ~buttons_in[0];
    assign pin1 = ~buttons_in[1];
    assign pin2 = pin6 ? ~buttons_in[2] : ~1'b0;
    assign pin3 = pin6 ? ~buttons_in[3] : ~1'b0;
    assign pin5 = pin6 ? ~buttons_in[5] : ~buttons_in[4];   // select ? B : A
    assign pin8 = pin6 ? ~buttons_in[6] : ~buttons_in[7];   // select ? C : Start

    // clocking
    reg system_clock = 0;
    always
        #10 system_clock = ~system_clock;
    
    reg frclk = 0;
	reg [31:0] counter = 0;
	reg [31:0] CounterLimit = 0;
	always @(posedge system_clock) begin
		CounterLimit <= 32;
		if (counter < CounterLimit)
			counter = counter + 1;
		else begin
			counter <= 0;
			frclk <= ~frclk;
		end
	end


    // controller module
    ControllerController cc(button_status,
                            pin0, pin1, pin2, pin3, pin5, pin6, pin8,
                            frclk, 1'b1, 1'b0);

endmodule