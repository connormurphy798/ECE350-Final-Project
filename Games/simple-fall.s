#
# simple jump test
#
# $state = 1 = FALLING = affected by gravity, cannot jump
# $state = 3 = GROUNDED = can move and jump
# $state = 4 = JUMPING = gravity off, moving upwards for some frames, cannot jump
#
##################################################################################################################

addi $r1, $r0, 1
addi $r3, $r0, 3
addi $r4, $r0, 4

beq $state, $r0, FALLING                                    # by default go to falling state for this test
beq $state, $r1, FALLING
beq $state, $r3, GROUNDED

# addi $bkg, SET INITIAL BACKGROUND POSITION

##################################################################################################################

FALLING:
    bbp 2, left_FALL
    bbp 3, right_FALL
    addi $r10, $r0, 3                           # free fall by 3 pixels at a time
    j CHECK_FALL

    left_FALL:
            addi $s2_x, $s2_x, -2
            #addi $sp2, SET LEFT FACING SPRITE
            j CHECK_FALL

    right_FALL:
            addi $s2_x, $s2_x, 2
            #addi $sp2, SET RIGHT FACING SPRITE
            j CHECK_FALL

    CHECK_FALL:
            # get current address of sprite
            #addi    $s2_x, $r0, 19              # set x to some number
            addi    $r4, $r0, 160               # w = 160
            mul     $r5, $s2_y, $r4             # y*w
            nop
            add     $r6, $r5, $s2_x             # y*w + x
            lw      $rtest1, 2560($r6)          # get contents at address y*w + x + 16*160
            nop
            lw      $rtest2, 2576($r60          # get contents at address y*w + x+16 + 16*160
            nop
            bne     $rtest1, $r0, change_to_grounded        # branch (don't update coordinates) if 1
            bne     $rtest2, $r0, change_to_grounded        
            
            # update sprite coordinates
            addi    $s2_y, $s2_y, 1             # y++

            addi $r10, $r10, -1                 # decrement counter
            bne $r10, $r0, CHECK_FALL           # loop until counter is 0
            j RENDER_FALL

    change_to_grounded:
            addi $state, $r0, 3                             # change to grounded state
            j RENDER_FALL

    RENDER_FALL:
            ren     sp2, $s2_x, $s2_y, $r0      # render sp2
            ren     bkg, $r0, $r0, $r0          # render bkg
            j EXIT

##################################################################################################################

GROUNDED:
    bbp 2, left_GROUND
    bbp 3, right_GROUND

    j CHECK_GROUND

    left_GROUND:
            addi $s2_x, $s2_x, -2
            #addi $sp2, SET LEFT FACING SPRITE
            j CHECK_GROUND

    right_GROUND:
            addi $s2_x, $s2_x, 2
            #addi $sp2, SET RIGHT FACING SPRITE
            j CHECK_GROUND

    CHECK_GROUND:
            addi    $r4, $r0, 160               # w = 160
            mul     $r5, $s2_y, $r4             # y*w
            nop
            add     $r6, $r5, $s2_x             # y*w + x
            lw      $rtest1, 2560($r6)          # get contents at address y*w + x + 16*160
            nop
            lw      $rtest2, 2576($r60          # get contents at address y*w + x+16 + 16*160
            nop
            bne     $rtest1, $r0, RENDER_GROUND        # stay grouned if 1
            bne     $rtest2, $r0, RENDER_GROUND

            addi $state, $r0, 1                 # enter falling state
            j RENDER_GROUND

    RENDER_GROUND:
            ren     sp2, $s2_x, $s2_y, $r0      # render sp2
            ren     bkg, $r0, $r0, $r0          # render bkg
            j EXIT

##################################################################################################################

EXIT:
    nop
    nop
    j EXIT