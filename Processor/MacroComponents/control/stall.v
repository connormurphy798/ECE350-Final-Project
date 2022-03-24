module stall(toALU_stall, instrFD, instrDX);
    input [31:0] instrFD, instrDX;
    output toALU_stall;

    // get the necessary instruction info
    wire [4:0] FD_rs, FD_rt, FD_rd, DX_rd;
    assign FD_rs = instrFD[21:17];
    assign FD_rt = instrFD[16:12];
    assign FD_rd = instrFD[26:22];
    assign DX_rd = instrDX[26:22];

    wire o4, o3, o2, o1, o0;
    assign o4 = instrDX[31];
    assign o3 = instrDX[30];
    assign o2 = instrDX[29];
    assign o1 = instrDX[28];
    assign o0 = instrDX[27];

    wire a4, a3, a2, a1, a0;
    assign a4 = instrDX[6];
    assign a3 = instrDX[5];
    assign a2 = instrDX[4];
    assign a1 = instrDX[3];
    assign a0 = instrDX[2];

    wire DX_islw, DX_issw, DX_isRtype, DX_ismuldiv, DX_rd_nonzero;
    assign DX_islw      = (~o4 &  o3 & ~o2 & ~o1 & ~o0);        // o01000 lw
    assign DX_issw      = (~o4 & ~o3 &  o2 &  o1 &  o0);        // o00111 lw
    assign DX_isRtype   = (~o4 & ~o3 & ~o2 & ~o1 & ~o0);        // o00000 R-type
    assign DX_ismuldiv  = (~a4 & ~a3 &  a2 &  a1) & DX_isRtype; // a0011x mul/div
    //assign DX_rd_nonzero= ~DX_rd[4] & ~DX_rd[3] & ~DX_rd[2] & ~DX_rd[1] & ~DX_rd[0];

    wire FD_reads_rs, FD_reads_rt, FD_reads_rd;
    reads_rs fdrrs(FD_reads_rs, instrFD);
    reads_rt fdrrt(FD_reads_rt, instrFD);
    reads_rd fdrrd(FD_reads_rd, instrFD);

    

    // toALU stall happens when a lw/mul/div is immediately followed by an instruction that reads their result
    // toALU_stall =    (instrDX.is_lw | instrDX.is_mul | instrDX.is_div) &
    //                  ((instrFD.rs == instrDX.rd & instrFD.reads_rs) |
    //                   (instrFD.rt == instrDX.rd & instrFD.reads_rt) |
    //                   (instrFD.rd == instrDX.rd & instrFD.reads_rd))
    assign toALU_stall =    (DX_islw | DX_ismuldiv) &
                            (   (FD_rs == DX_rd & FD_reads_rs) |
                                (FD_rt == DX_rd & FD_reads_rt & ~DX_issw));
                            //DX_rd_nonzero;



endmodule