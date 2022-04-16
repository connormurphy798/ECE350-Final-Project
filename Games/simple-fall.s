
CHECK_FALL:
    # get current address of sprite
    addi    $s2_x, $r0, 19              # set x to some number
    addi    $r4, $r0, 160               # w = 160
    mul     $r5, $s2_y, $r4             # y*w
    add     $r6, $r5, $s2_x             # y*w + x
    lw      $rtest1, 2560($r6)          # get contents at address y*w + x + 16*160
    nop
    bne     $rtest1, $r0, RENDER        # branch (don't update coordinates) if 1
    
    # update sprite coordinates
    addi    $s2_y, $s2_y, 1             # y++

RENDER:
    ren     sp2, $s2_x, $s2_y, $r0      # render sp2
    ren     bkg, $r0, $r0, $r0          # render bkg
EXIT:
    nop
    nop
    j EXIT