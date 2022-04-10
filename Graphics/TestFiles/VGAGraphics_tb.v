`timescale 1ns / 1ps
module VGAGraphics_tb();


    reg clk = 1'b0;
    always
		#10 clk = ~clk;

    wire hSync, vSync, pin6;
    wire[3:0] VGA_R, VGA_G, VGA_B;
    wire [7:0] buttons;
    wire [3:0] curr;
    wire fr;
    VGAGraphics vga(clk, 1'b0, hSync, vSync, VGA_R, VGA_G, VGA_B, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, pin6, 1'b1, buttons, curr, fr);


    always @(posedge clk) begin
        $display("current state: %d, force reset: %d\n", curr, fr);
    end


    // waveform
    initial begin
        $dumpfile("Graphics/TestFiles/graphics.vcd");
        $dumpvars(0, VGAGraphics_tb);
    end



endmodule