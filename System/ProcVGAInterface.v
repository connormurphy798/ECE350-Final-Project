/**
 *
 *  Interface from the processor to the VGA controller.
 *
 **/

module ProcVGAInterface(
    input sysclk,
    input frclk,
    input gmem_en,
    input [31:0] addr_gmem_IN,
    input [7:0] x_coord_IN,
    input [6:0] y_coord_IN,
    input [1:0] imgcode_IN,

    output draw_OUT,                    // TODO: augment with sprite logic
    output [31:0] addr_gmem_OUT,
    output [7:0] x_coord_OUT,
    output [6:0] y_coord_OUT
    );

    wire draw;              
    wire [31:0] addr_gmem;
    wire [7:0] x_coord;
    wire [6:0] y_coord;

    // clocked on system clock
    IM_reg reg0(addr_gmem,      x_coord,    y_coord,    draw,
                addr_gmem_IN,   x_coord_IN, y_coord_IN, (imgcode_IN == 2'b00 & gmem_en),
                sysclk, (imgcode_IN == 2'b00 & gmem_en), 1'b0);
    
    // clocked on frame clock
    IM_reg reg1(addr_gmem_OUT,  x_coord_OUT,    y_coord_OUT,    draw_OUT,
                addr_gmem,      x_coord,        y_coord,        draw,
                frclk, 1'b1, 1'b0);



endmodule