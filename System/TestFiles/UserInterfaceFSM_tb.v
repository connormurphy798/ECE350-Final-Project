`timescale 1ns / 1ps
module UserInterfaceFSM_tb();

    reg [7:0] buttons = 8'b00000000;
    wire [3:0] curr;

    reg clk = 0;
    reg en = 1;
    reg clr = 0;
    always
		#10 clk = ~clk;

    UserInterfaceFSM fsm(curr, buttons, clk, en, clr);


    always @(posedge clk) begin
        $display("current state: %d\n", curr);
    end


    // waveform
    initial begin
        $dumpfile("System/TestFiles/cc.vcd");
        $dumpvars(0, UserInterfaceFSM_tb);
    end



endmodule