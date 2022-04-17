/**
 *
 *  Interface from the processor to the audio controller.
 *
 **/
 
module ProcAudioInterface(
    input       clk25,      // System clock
    input       frclk,      // Frame clock
    input[16:0] dur,        // Duration of note
    input       start,      // Begin new note
    input       reset,      // Reset signal
    output      audioEn     // Audio enable 
    );

    // store last duration received + number of frames played so far
    wire signed [31:0] duration;
    wire signed [31:0] frame_count;

    // stop playing when frame_count exceeds duration
    assign audioEn = frame_count < duration;

    // update duration when new start signal received
    reg32b d(duration, {15'b0, dur}, clk25, start, reset | ~audioEn);

    // update frame_count every frame
    reg32b c(frame_count, frame_count + 32'b1, frclk, 1'b1, reset | ~audioEn);


    /*
    // dur = number of frames for which a sound should play
    wire signed [31:0] frame_count_IN;     // count_reg input
    wire signed [31:0] frame_count_OUT;    // count_reg output
    wire signed [31:0] frame_count_NEXT;   // count_reg decremented value
    wire signed [31:0] zero = 32'b0;
    assign frame_count_NEXT = (frame_count_OUT == zero) ? 32'b0 : frame_count_OUT - 1;
    assign frame_count_IN = start ? {15'b0, dur} : frame_count_NEXT;


    // enable sound as long as frame count is nonzero

    reg32b count_reg(frame_count_OUT, frame_count_IN, frclk, 1'b1, reset);
    assign audioEn = (frame_count_OUT != zero);
    */

endmodule