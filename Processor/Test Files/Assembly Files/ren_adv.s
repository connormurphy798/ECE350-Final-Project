nop                                 # advanced ren test, double bypassing, MX+WX.
nop                                 # note that since ren doesn't affect the CPU's state, 
nop                                 # you have to check gtkwave to glean anything here.
nop
addi        $r1, $r0, 29
addi        $r2, $r0, 18
nop
nop
nop
nop
addi        $r3, $r0, 376           # $r3 = 376, bypass $rd
add         $r6, $r1, $r1           # $r6 = 58, bypass $rs                  
ren         sp1, $r6, $r2, $r3      # tell graphics to render sp1 at (58,18) using data from GMEM[376]
nop
nop
nop
nop
add         $r8, $r6, $r1           # $r8 = 87, bypass $rs
sub         $r9, $r1, $r2           # $r9 = 11, RAW hazard, bypass $rt
ren         sp2, $r8, $r9, $r3      # tell graphics to render sp2 at (87,11) using data from GMEM[376]
nop
nop
nop
sub         $r7, $r1, $r2           # $r7 = 11    
addi        $r11, $r2, 7            # $r11 = 25, RAW hazard, bypass $rt
add         $r12, $r3, $r3          # $r12 = 752, RAW hazard, bypass $rd
ren         bkg, $r6, $r11, $r12    # tell graphics to render bkg at (58,25) using data from GMEM[752]
nop
nop
nop
nop