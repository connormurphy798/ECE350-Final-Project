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

    output draw_BKG,                    // TODO: augment with sprite logic
    output [31:0] addr_gmem_BKG,
    output [7:0] x_coord_BKG,
    output [6:0] y_coord_BKG,

    output draw_SP1,                    // TODO: augment with sprite logic
    output [31:0] addr_gmem_SP1,
    output [7:0] x_coord_SP1,
    output [6:0] y_coord_SP1
    );



    // --------------------------------- BKG ---------------------------------------

    wire draw00;              
    wire [31:0] addr_gmem00;
    wire [7:0] x_coord00;
    wire [6:0] y_coord00;

    // clocked on system clock
    IM_reg bkgS(addr_gmem00,    x_coord00,  y_coord00,  draw00,
                addr_gmem_IN,   x_coord_IN, y_coord_IN, (imgcode_IN == 2'b00 & gmem_en),
                sysclk, (imgcode_IN == 2'b00 & gmem_en), 1'b0);
    
    // clocked on frame clock
    IM_reg bkgF(addr_gmem_BKG,  x_coord_BKG,    y_coord_BKG,    draw_BKG,
                addr_gmem00,    x_coord00,      y_coord00,      draw00,
                frclk, 1'b1, 1'b0);
    


    // --------------------------------- SP1 ---------------------------------------

    wire draw01;              
    wire [31:0] addr_gmem01;
    wire [7:0] x_coord01;
    wire [6:0] y_coord01;

    // clocked on system clock
    IM_reg sp1S(addr_gmem01,    x_coord01,  y_coord01,  draw01,
                addr_gmem_IN,   x_coord_IN, y_coord_IN, (imgcode_IN == 2'b01 & gmem_en),
                sysclk, (imgcode_IN == 2'b01 & gmem_en), 1'b0);
    
    // clocked on frame clock
    IM_reg sp1F(addr_gmem_SP1,  x_coord_SP1,    y_coord_SP1,    draw_SP1,
                addr_gmem01,    x_coord01,      y_coord01,      draw01,
                frclk, 1'b1, 1'b0);



endmodule