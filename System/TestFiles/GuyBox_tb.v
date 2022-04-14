`timescale 1ns / 1ps
module GuyBox_tb();


    reg clk = 0 ;
    reg clr = 0;
    wire sel;
    wire [7:0] buttons;
    wire [3:0] curr;

    wire pin5;
    wire pin8;

    wire hSync, vSync;
    wire [3:0] VGA_R, VGA_G, VGA_B;

    
    always
		#10 clk = ~clk; 

    GuyBox gb(.clk(clk), .reset(clr),
                .pin0(1'b1), .pin1(1'b1), .pin2(1'b1), .pin3(1'b1),
                .pin5(pin5), .pin6(sel), .pin8(pin8),
                .hSync(hSync), .vSync(vSync),
                .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B),
                .buttons(buttons), .curr(curr)
                );

    reg [31:0] counter = 4'b0;
    assign pin5 = counter[8];
    assign pin8 = counter[12];
    always @(posedge clk) begin
        counter = counter + 1;
        $display("current state: %d\nbuttons: %b\n%d, %d, %h%h%h\n", curr, buttons, hSync, vSync, VGA_R, VGA_G, VGA_B);
    end


    // waveform
    initial begin
        $dumpfile("System/TestFiles/guybox.vcd");
        $dumpvars(0, GuyBox_tb);
    end



endmodule