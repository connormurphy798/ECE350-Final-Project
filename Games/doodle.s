#
# simple jump test
#
# $state = 1 = FALLING = affected by gravity, cannot jump
# $state = 3 = JUMPING = gravity off, moving upwards for some frames, cannot jump
# $state = 4 = DEAD
#
##################################################################################################################

addi $r1, $r0, 1
addi $r3, $r0, 3
addi $r4, $r0, 4

beq $state, $r0, OPENING                                   
beq $state, $r1, FALLING
beq $state, $r3, JUMPING
beq $state, $r4, DEAD


OPENING:
    addi $state, $r0, 1
    addi $bkg, $r0, 57600
    addi $s2_x, $r0, 20
    addi $s2_y, $r0, 57
    j EXIT

##################################################################################################################

FALLING:
    addi $r10, $r0, 3                           # free fall by 3 pixels at a time
    bbp 2, left_FALL
    bbp 3, right_FALL
    j CHECK_FALL

    left_FALL:
            addi $r2, $r0, 2
            nop
            blt $s2_x, $r2, appear_right_fall
            addi $s2_x, $s2_x, -2
            addi $sp2, $r0, 0
            j CHECK_FALL

            appear_right_fall:
                addi $s2_x, $r0, 159
                addi $sp2, $r0, 0
                j CHECK_FALL

    right_FALL:
            addi $r3, $r0, 158
            nop
            blt $r3, $s2_x, appear_left_fall
            addi $s2_x, $s2_x, 2
            addi $sp2, $r0, 256
            j CHECK_FALL

            appear_left_fall:
                addi $s2_x, $r0, 0
                addi $sp2, $r0, 256
                j CHECK_FALL

    CHECK_FALL:
            addi $r11, $r0, 103                 # death point
            nop
            blt $r11, $s2_y, DEATH 

            addi    $r4, $r0, 160               # w = 160
            mul     $r5, $s2_y, $r4             # y*w
            nop
            add     $r6, $r5, $s2_x             # y*w + x
            add     $r6, $r6, $bkg
            lw      $rtest1, 2560($r6)          # get contents at address y*w + x + 16*160
            nop
            lw      $rtest2, 2576($r6)          # get contents at address y*w + x+16 + 16*160
            nop
            bne     $rtest1, $r0, GROUNDED      # branch (don't update coordinates) if 1
            bne     $rtest2, $r0, GROUNDED       
            
            # update sprite coordinates
            addi    $s2_y, $s2_y, 1             # y++

            addi $r10, $r10, -1                 # decrement counter
            nop
            nop
            bne $r10, $r0, CHECK_FALL           # loop until counter is 0
            j RENDER_FALL

    GROUNDED:
            beq $r14, $r0, no_lockout
            addi $r14, $r14, -1                 # decrement jump lockout
            j RENDER_FALL

            no_lockout:
            bbp 5, JUMP                         # jump on B press
            j RENDER_FALL

    JUMP:
            addi $state, $r0, 3                 # enter jumping state
            addi $r10, $r0, 15                  # jump for 15 frames
            j RENDER_FALL

    DEATH:
            addi $state, $r0, 4
            j RENDER_FALL

    RENDER_FALL:
            ren     sp2, $s2_x, $s2_y, $sp2      # render sp2
            ren     bkg, $r0, $r0, $bkg         # render bkg
            j EXIT

##################################################################################################################

JUMPING:
    bbp 5, cont
        j END_JUMP
        nop
        nop
        nop
    cont:
    beq $r10, $r1, END_JUMP                     # on last frame, change state
    bbp 2, left_JUMP
    bbp 3, right_JUMP
    j RENDER_JUMP

    left_JUMP:
            addi $s2_x, $s2_x, -2
            addi $sp2, $r0, 0
            j RENDER_JUMP

    right_JUMP:
            addi $s2_x, $s2_x, 2
            addi $sp2, $r0, 256
            j RENDER_JUMP

    END_JUMP:
            addi $state, $r0, 1
            addi $r14, $r0, 5                   # can't jump again for 5 grounded cycles
            j RENDER_JUMP

    RENDER_JUMP:
            addi $r3, $r0, 3
            addi $r4, $r0, 480
            addi $r11, $r0, 45                  # screen breakpoint
            nop
            nop
            blt $r11, $s2_y, change_y           # until breakpoint, change y instead of background
            nop
            blt $bkg, $r4, hold_bkg             # make sure bkg doesn't go lower than 0
            addi $r10, $r10, -1                 # decrement counter
            addi $bkg, $bkg, -480               # move background up by 3 pixels
            j done

            hold_bkg:
                addi $bkg, $r0, 0
                j done

            change_y:
                addi $s2_y, $s2_y, -3
                addi $r10, $r10, -1             # decrement counter
                j done
            

            done:
            ren     sp2, $s2_x, $s2_y, $sp2     # render sp2
            ren     bkg, $r0, $r0, $bkg         # render bkg
            j EXIT

##################################################################################################################

DEAD:
    bbp 7, ENDGAME
    addi $bkg, $r0, 76800
    ren bkg, $r0, $r0, $bkg
    addi $s2_x, $r0, 72
    addi $s2_y, $r0, 80
    addi $sp2, $r0, 512
    ren sp2, $s2_x, $s2_y, $sp2
    j EXIT

    ENDGAME:
        QUITGAME $r1

EXIT:
    nop
    nop
    j EXIT