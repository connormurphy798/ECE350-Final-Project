/**
 *
 *  Module for interfacing with the Sega Genesis 3-button controller.
 *  
 *
 **/

module ControllerController(
    // Output
    buttons,                    // the state of the buttons on the previous frame
    
    // Controller pins
    pin0,                       // UP       (in)
    pin1,                       // DOWN     (in)    
    pin2,                       // LEFT     (in)    L when select, 0 when ~select
    pin3,                       // RIGHT    (in)    R when select, 0 when ~select
    //pin4,                     // +5V      (out)   handled separately
    pin5,                       // B/A      (in)    B when select, A when ~select
    pin6,                       // select   (out)
    //pin7,                     // GND      (out)   handled separately
    pin8,                       // C/Start  (in)    C when select, Start when ~select

    // DFF inputs
    sysclk
    //frclk,                      // frame clock - period is length of one frame
    //en,
    //clr   
    );


    // Output to console
    output [7:0] buttons;   // {Start, C, B, A, Right, Left, Down, Up}

    // Input from console
    //input frclk, en, clr;
    input sysclk;
    reg frclk = 0;
	reg [31:0] counter = 0;
	reg [31:0] CounterLimit = 0;
	always @(posedge sysclk) begin
		CounterLimit <= 32;
		if (counter < CounterLimit)
			counter = counter + 1;
		else begin
			counter <= 0;
			frclk <= ~frclk;
		end
	end
        
    
    wire en, clr;
    assign en = 1;
    assign clr = 0;

    // Output to controller
    output pin6;

    // Input from controller
    input pin0, pin1, pin2, pin3;
    input pin5, pin8;


    // toggle select every frame
    reg select = 1;
    always @(posedge frclk) begin
       select = ~select; 
    end
    assign pin6 = select;


    // ---- Store previous frame's button input in DFFs ---
    wire up, down, left, right, a, b, c, start; // controller gives 0 when pressed, 1 when not - want to invert
    wire slct_en  =  select & en;
    wire nslct_en = ~select & en; 

    // UP
    dffe_ref UP(up, pin0, frclk, en, clr);
    assign buttons[0] = ~up;

    // DOWN
    dffe_ref DOWN(down, pin1, frclk, en, clr);
    assign buttons[1] = ~down;

    // LEFT
    dffe_ref LEFT(left, pin2, frclk, slct_en, clr);
    assign buttons[2] = ~left;

    // RIGHT
    dffe_ref RIGHT(right, pin3, frclk, slct_en, clr);
    assign buttons[3] = ~right;

    // A
    dffe_ref A(a, pin5, frclk, nslct_en, clr);
    assign buttons[4] = ~a;

    // B
    dffe_ref B(b, pin5, frclk, slct_en, clr);
    assign buttons[5] = ~b;

    // C
    dffe_ref C(c, pin8, frclk, slct_en, clr);
    assign buttons[6] = ~c;
    
    // START
    dffe_ref START(start, pin8, frclk, nslct_en, clr);
    assign buttons[7] = ~start;

endmodule