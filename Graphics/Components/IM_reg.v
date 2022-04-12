module IM_reg(  addr_out, x_out, y_out, draw_out,
                addr_in,  x_in,  y_in,  draw_in,
                clk, en, clr);

    input [31:0] addr_in;
    input [7:0] x_in;
    input [6:0] y_in;
    input draw_in;
    input clk, en, clr;

    output [31:0] addr_out;
    output [7:0] x_out;
    output [6:0] y_out;
    output draw_out;

    // 32-bit register for GMEM address
    reg32b addr_reg(addr_out, addr_in, clk, en, clr);

    // 8-bit register for x coordinate
    reg8b x_reg(x_out, x_in, clk, en, clr);

    // 7-bit register for y coordinate
    reg7b y_reg(y_out, y_in, clk, en, clr);

    // dffe for draw status
    dffe_ref d_dffe(draw_out, draw_in, clk, en, clr);

endmodule

