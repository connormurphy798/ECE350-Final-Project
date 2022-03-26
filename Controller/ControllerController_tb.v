`timescale 1ns / 1ps
/**
 *
 *  Testbench for the ControllerController module.
 *
 **/

module ControllerController_tb();
    // simulated controller button input
    reg [7:0] buttons_in = 8'b11111111; // starting with no buttons pressed, remembering that the controller asserts 0 when pressed

    // simulated controller output to console
    wire pin0, pin1, pin2, pin3, pin5, pin6, pin8;
    assign pin0 = buttons_in[0];
    assign pin1 = buttons_in[1];
    assign pin2 = pin6 ? buttons_in[2] : 1'b0;
    assign pin3 = pin6 ? buttons_in[3] : 1'b0;
    assign pin5 = pin6 ? buttons_in[5] : buttons_in[4];   // select ? B : A
    assign pin8 = pin6 ? buttons_in[6] : buttons_in[7];   // select ? C : Start


    // button presses detected by console
    wire [7:0] buttons_det;
    reg frclk = 0;
    reg en = 1;
    reg clr = 0;

    ControllerController ctrlr( buttons_det,
                                pin0, pin1, pin2, pin3, pin5, pin6, pin8,
                                frclk, en, clr);

    // clocking
    reg system_clock = 0;   // system clock will operate much faster than frame clock
    always
		    #10 system_clock = ~system_clock;

    reg [31:0] counter = 0;
	  wire [31:0] CounterLimit = 1;   // for now, say a frame clock cycle is 2 system clock cycles (high for 1, low for 1)
    always @(posedge system_clock) begin
        if (counter < CounterLimit)
            counter = counter + 1;
        else begin
            counter <= 0;
            frclk <= ~frclk;
        end
	  end

    reg [8:0] simcounter = 0;
    always @(posedge frclk) begin
        #5 // delay to stabilize select value
        $display("frame %h: s=%b, %b ==> %b\n", simcounter, pin6, buttons_in, buttons_det);
        simcounter <= simcounter + 1;
        if (simcounter == 511)
            $finish;
        if (simcounter[0] == 0)
            buttons_in <= buttons_in - 1;
    end


    // waveform
    initial begin
        $dumpfile("Controller/Test Files/cc.vcd");
        $dumpvars(0, ControllerController_tb);
    end



endmodule
