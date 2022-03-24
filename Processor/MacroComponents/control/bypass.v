module bypass(ALUinA, ALUinB, MemData, MULTDIVinA, MULTDIVinB, ALUexcptA, ALUexcptB, exceptval, instrDX, instrXM, instrMW, instrXC, excptXM);
    input [31:0] instrDX, instrXM, instrMW, instrXC;
    input excptXM;

    output [1:0] ALUinA, ALUinB;
    output MemData, MULTDIVinA, MULTDIVinB;
    output ALUexcptA, ALUexcptB;
    output [31:0] exceptval;

    // specialized instructions like setx/bex don't have an explicit $rd, just set to $30
    wire XM_issetx, MW_issetx, XM_isbex, MW_isbex;
    assign XM_issetx =  instrXM[31] & ~instrXM[30] &  instrXM[29] & ~instrXM[28] &  instrXM[27]; // 10101 setx
    assign MW_issetx =  instrMW[31] & ~instrMW[30] &  instrMW[29] & ~instrMW[28] &  instrMW[27];
    //assign XM_isbex  =  instrXM[31] & ~instrXM[30] &  instrXM[29] &  instrXM[28] & ~instrXM[27]; // 10110 bex
    //assign MW_isbex  =  instrMW[31] & ~instrMW[30] &  instrMW[29] &  instrMW[28] & ~instrMW[27];

    // get the register codes from the instructions
    wire [4:0] DX_rs, DX_rt, DX_rd, XM_rd, MW_rd, XC_rs, XC_rt;
    assign DX_rs = instrDX[21:17];
    assign DX_rt = instrDX[16:12];
    assign DX_rd = instrDX[26:22];
    assign XM_rd = XM_issetx ? 5'b11110 : instrXM[26:22];
    assign MW_rd = MW_issetx ? 5'b11110 : instrMW[26:22];
    assign XC_rs = instrXC[21:17];
    assign XC_rt = instrXC[16:12];

    // bypassing zero
    wire XM_rd_nonzero, MW_rd_nonzero;
    assign XM_rd_nonzero = (XM_rd[4] | XM_rd[3] | XM_rd[2] | XM_rd[1] | XM_rd[0]);
    assign MW_rd_nonzero = (MW_rd[4] | MW_rd[3] | MW_rd[2] | MW_rd[1] | MW_rd[0]); 

    // determine which instructions read from/write to which registers
    wire DX_reads_rs, DX_reads_rt, DX_reads_rd, XM_writes_rd, MW_writes_rd;
    reads_rs  dxrrs(DX_reads_rs,  instrDX);
    reads_rt  dxrrt(DX_reads_rt,  instrDX);
    reads_rd  dxrrd(DX_reads_rd,  instrDX);
    writes_rd xmwrd(XM_writes_rd, instrXM);
    writes_rd mwwrd(MW_writes_rd, instrMW);

    // special case for exceptions in M stage
    wire [4:0] r30 = 5'b11110;
    wire [31:0] exceptval_pre;
    exception excpt(exceptval_pre, excptXM, instrXM);
    assign exceptval = XM_issetx ? {5'b0, instrXM[26:0]} : exceptval_pre;
    // A: (instrDX.rs == 30) & (instrDX.reads_rs) & (instrXM.has_exception)
    assign ALUexcptA =  (DX_rs == r30) &
                        (DX_reads_rs) &
                        (excptXM) |
                        XM_issetx;

    // B: ((instrDX.rt == 30 & instrDX.reads_rt) | (instrDX.rd == 30 & instrDX.reads_rd)) & (instrXM.has_exception)
    assign ALUexcptB =  ((DX_rt == r30 & DX_reads_rt) | (DX_rd == r30 & DX_reads_rd)) &
                        (excptXM) |
                        XM_issetx;


    // ALUinA code (MX bypass takes precedence)
    //      00 - no bypass
    //      01 - WX bypass
    //          (instrDX.rs == instrMW.rd) & (instrDX.reads_rs) & (instrMW.writes_rd) & (instrMW.rd != 0)
    //      1x - MX bypass:
    //          (instrDX.rs == instrXM.rd) & (instrDX.reads_rs) & (instrXM.writes_rd) & (instrXM.rd != 0)
    assign ALUinA[0] =  (DX_rs == MW_rd) &
                        (DX_reads_rs) &
                        (MW_writes_rd) &
                        (MW_rd_nonzero);
    assign ALUinA[1] =  (DX_rs == XM_rd) &
                        (DX_reads_rs) &
                        (XM_writes_rd) &
                        (XM_rd_nonzero);


    // ALUinB code (MX bypass takes precedence)
    //      00 - no bypass
    //      01 - WX bypass
    //          ((instrDX.rt == instrMW.rd) & (instrDX.reads_rt) | (instrDX.rd == instrMW.rd) & (instrDX.reads_rd)) & (instrMW.writes_rd) & (instrMW.rd != 0)
    //      1x - MX bypass:
    //          ((instrDX.rt == instrXM.rd) & (instrDX.reads_rt) | (instrDX.rd == instrXM.rd) & (instrDX.reads_rd)) & (instrXM.writes_rd) & (instrXM.rd != 0)
    assign ALUinB[0] =  ((DX_rt == MW_rd & DX_reads_rt) | (DX_rd == MW_rd & DX_reads_rd)) &
                        (MW_writes_rd) &
                        (MW_rd_nonzero);
    assign ALUinB[1] =  ((DX_rt == XM_rd & DX_reads_rt) | (DX_rd == XM_rd & DX_reads_rd)) &
                        (XM_writes_rd) &
                        (XM_rd_nonzero);


    // MemData code
    //      0 - no bypass
    //      1 - WM bypass
    //          (instrXM.rd == instrMW.rd) & (instrXM.writes_mem) & (instrMW.writes_rd) & (instrMW.rd != 0)
    //              (instrXM.writes_mem) isn't actually necessary - write enable is off if instrXM doesn't write to mem
    assign MemData  =   (XM_rd == MW_rd) &
                        (MW_writes_rd) &
                        (MW_rd_nonzero);
    

    // MULTDIVinA code
    //      0 - no bypass
    //      1 - WC bypass
    //          (instrXC.rs == instrMW.rd) & (instrMW.writes_rd) & (instrMW.rd != 0)
    assign MULTDIVinA = (XC_rs == MW_rd) &
                        (MW_writes_rd) &
                        (MW_rd_nonzero);


    // MULTDIVinB code
    //      0 - no bypass
    //      1 - WC bypass
    //          (instrXC.rt == instrMW.rd) & (instrMW.writes_rd) & (instrMW.rd != 0)
    assign MULTDIVinB = (XC_rt == MW_rd) &
                        (MW_writes_rd) &
                        (MW_rd_nonzero);
 endmodule