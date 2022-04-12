`timescale 1ns / 1ps
module GuyBox_tb();


    reg clk = 0;
    reg clr = 0;
    wire sel;
    wire [7:0] buttons;
    wire [3:0] curr;

    wire hSync, vSync;
    wire [3:0] VGA_R, VGA_G, VGA_B;

    always
		#10 clk = ~clk;

    GuyBox gb(.clk(clk), .reset(clr),
                .pin0(1'b1), .pin1(1'b1), .pin2(1'b1), .pin3(1'b1),
                .pin5(1'b1), .pin6(sel), .pin8(1'b0),
                .hSync(hSync), .vSync(vSync),
                .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B),
                .buttons(buttons), .curr(curr)
                );


    always @(posedge clk) begin
        $display("current state: %d\nbuttons: %b\n%d, %d, %h%h%h\n", curr, buttons, hSync, vSync, VGA_R, VGA_G, VGA_B);
    end


    // waveform
    initial begin
        $dumpfile("System/TestFiles/guybox.vcd");
        $dumpvars(0, GuyBox_tb);
    end



endmodule