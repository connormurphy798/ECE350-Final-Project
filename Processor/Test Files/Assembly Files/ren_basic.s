nop                                 # simple ren test, no bypassing.
nop                                 # note that since ren doesn't affect the CPU's state, 
nop                                 # you have to check gtkwave to glean anything here.
nop
addi        $r1, $r0, 29
addi        $r2, $r0, 18
addi        $r3, $r0, 376
nop                                 # \
nop                                 #  } prevent RAW hazard
nop                                 # /
ren         sp1, $r1, $r2, $r3      # tell graphics to render sp1 at (29,18) using data from GMEM[376]
nop
nop
nop
nop