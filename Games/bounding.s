
# current position
    addi    $r10, $r10, 256         # $r10 = w
    mul     $r9, $s1_y, $r10        # $r9 = y*w
    add     $r9, $r9, $s1_x         # $r9 = y*w + x (DMEM address of current top left)

# -------------- get button presses --------------
UP:
    sbp     $r1, 0                  # $r1 = UP
    nop
    nop
    nop
    nop
    beq     $r1, $r0, DOWN          # branch if UP not pressed

    addi    $r8, $r9, -160          # get purported next top left: CURRENT_POS - 160
    lw      $rtest1, 0($r8)         # get the value at that address - 1 if wall, 0 if no wall
    # addi    $rtest1, $r0, 1 
    nop                             # safety

    bne     $rtest1, $r0, DOWN      # branch if gonna hit a wall
    addi    $s1_y, $s1_y, -1        # y-- if made it here
    j		RENDER
    


DOWN:
    sbp     $r2, 1                  # $r2 = DOWN
    nop
    nop
    nop
    nop
    beq     $r2, $r0, LEFT          # branch if DOWN not pressed

    addi    $r8, $r9, 160           # CURRENT_POS + 160
    lw      $rtest1, 0($r8) 
    # addi    $rtest1, $r0, 1             
    nop

    bne     $rtest1, $r0, LEFT
    addi    $s1_y, $s1_y, 1         # y++ if made it here
    j		RENDER


LEFT:
    sbp     $r3, 2                  # $r3 = LEFT
    nop
    nop
    nop
    nop
    beq     $r3, $r0, RIGHT         # branch if LEFT not pressed

    addi    $r8, $r9, -1            # CURRENT_POS - 1
    lw      $rtest1, 0($r8) 
    # addi    $rtest1, $r0, 1             
    nop

    bne     $rtest1, $r0, RIGHT
    addi    $s1_x, $s1_x, -1        # x-- if made it here
    j		RENDER


RIGHT:
    sbp     $r4, 3                  # $r4 = RIGHT
    nop
    nop
    nop
    nop
    beq     $r4, $r0, RENDER        # branch if RIGHT not pressed

    addi    $r8, $r9, 1             # CURRENT_POS + 1
    lw      $rtest1, 0($r8)  
    # addi    $rtest1, $r0, 1            
    nop

    bne     $rtest1, $r0, RENDER
    addi    $s1_x, $s1_x, 1         # x++ if made it here
    j		RENDER


RENDER:
    addi    $rtest2, $r0, 1         # testing purposes
    ren     bkg, $r0, $r0, $r0
    ren     sp1, $s1_x, $s1_y, $r0


EXIT:
    j EXIT

