/**
 *
 *  Module for controlling the GuyBox audio.
 *  Original module written by ECE350 course staff,
 *  modified by the GuyBox team.
 *
 **/

module AudioController(
    input       clk25,     // System Clock Input 25 Mhz
    input       frclk,      // Frame clock
    input[4:0]  freq,	    // Frequency code
    input[16:0] dur,        // Duration of note
    input       start,      // Begin new note
    input       reset,      // Reset signal
    output      audioEn,    // Audio enable     
    output      audioOut);	// PWM signal to the audio jack	


	localparam MHz = 1000000;
	localparam SYSTEM_FREQ = 25*MHz; // System clock frequency


    // Determine audio enable
    ProcAudioInterface interface(.clk25(clk25), .frclk(frclk), .dur(dur), .start(start), .reset(reset), .audioEn(audioEn));


	// Initialize the frequency array.
    //      FREQS[0]    = 083 (C3)
    //      FREQS[12]   = 105 (C4) 
    //      FREQS[24]   = 20b (C5)
	reg[10:0] FREQs[0:24];
	initial begin
		$readmemh("FREQs.mem", FREQs);
	end
	


	reg clkCL = 0;
	reg [31:0] counter = 0;
	reg [31:0] CounterLimit = 0;
	always @(posedge clk25) begin
		CounterLimit <= (SYSTEM_FREQ/(2*FREQs[freq])) - 1;
		if (counter < CounterLimit)
			counter = counter + 1;
		else begin
			counter <= 0;
			clkCL <= ~clkCL;
		end
	end

	wire [6:0] max, min;
	assign max = 80;
	assign min = 20;


	wire [6:0] duty_cycle;
	assign duty_cycle = clkCL ? max : min;

	PWMSerializer pwm(clk25, 1'b0, duty_cycle, audioOut);
	

endmodule