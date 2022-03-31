nop                                 # intermediate ren test, single bypassing, all MX.
nop                                 # note that since ren doesn't affect the CPU's state, 
nop                                 # you have to check gtkwave to glean anything here.
nop
addi        $r1, $r0, 29
addi        $r2, $r0, 18
nop
nop
nop
nop
addi        $r3, $r0, 376           # RAW hazard, bypass $rd                  
ren         sp1, $r1, $r2, $r3      # tell graphics to render sp1 at (29,18) using data from GMEM[376]
nop
nop
nop
nop
add         $r6, $r1, $r1           # RAW hazard, bypass $rs
ren         sp2, $r6, $r2, $r3      
nop
nop
nop
nop
sub         $r7, $r1, $r2           # RAW hazard, bypass $rt
ren         bkg, $r6, $r7, $r3
nop
nop
nop
nop