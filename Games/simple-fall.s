#
# simple jump test
#
# $state = 1 = FALLING = affected by gravity, cannot jump
# $state = 3 = JUMPING = gravity off, moving upwards for some frames, cannot jump
#
##################################################################################################################

addi $r1, $r0, 1
addi $r3, $r0, 3

beq $state, $r0, OPENING                                    # by default go to falling state for this test
beq $state, $r1, FALLING
beq $state, $r3, JUMPING

# addi $bkg, SET INITIAL BACKGROUND POSITION

OPENING:
    bbp 7, start_OPEN
    bne $state_buff, $r0, change_to_game
    j OPEN_DONE

    start_OPEN:                                 # on START press
        addi $state_buff, $r0, 1                # put 1 into state buffer
        j OPEN_DONE

    change_to_game:
        addi $state_buff, $r0, 0                # reset state buffer
        addi $state, $r0, 1                     # change to GAMEPLAY state

        addi $bkg, $r0, 0                       # render opening background
        ren bkg, $r0, $r0, $bkg                 # |

        addi $bkg, $r0, 38400                   # render game background next
        addi $sp2, $r0, 0                       # render sprite at memory 0 next

        ######## INITIALIZE SPRITE POSITION ########
        addi $s1_x, $r0, 16
        addi $s1_y, $r0, 16

        j EXIT

    OPEN_DONE:
        addi $bkg, $r0, 0                       # render opening background
        ren bkg, $r0, $r0, $bkg                 # |
        addi $s2_x, $r0, 164                    # render sprite offscreen
        addi $s2_y, $r0, 7                      # | 
        ren sp2, $s2_x, $s2_y, $r0              # |
        j EXIT

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
            lw      $rtest2, 2576($r6)          # get contents at address y*w + x+16 + 16*160
            nop
            bne     $rtest1, $r0, GROUNDED      # branch (don't update coordinates) if 1
            bne     $rtest2, $r0, GROUNDED       
            
            # update sprite coordinates
            addi    $s2_y, $s2_y, 1             # y++

            addi $r10, $r10, -1                 # decrement counter
            #bne $r10, $r0, CHECK_FALL           # loop until counter is 0
            j RENDER_FALL

    GROUNDED:
            bbp 5, JUMP                         # jump on B press
            j RENDER_FALL

    JUMP:
            addi $state, $r0, 3                 # enter jumping state
            addi $r10, $r0, 30                  # jump for 30 frames
            j RENDER_FALL

    RENDER_FALL:
            ren     sp2, $s2_x, $s2_y, $r0      # render sp2
            ren     bkg, $r0, $r0, $bkg         # render bkg
            j EXIT

##################################################################################################################

JUMPING:
    beq $r10, $r1, END_JUMP                     # on last frame, change state
    bbp 2, left_JUMP
    bbp 3, right_JUMP
    j RENDER_JUMP

    left_JUMP:
            addi $s2_x, $s2_x, -2
            #addi $sp2, SET LEFT FACING SPRITE
            j RENDER_JUMP

    right_JUMP:
            addi $s2_x, $s2_x, 2
            #addi $sp2, SET RIGHT FACING SPRITE
            j RENDER_JUMP

    END_JUMP:
            addi $state, $r0, 1
            j RENDER_JUMP

    RENDER_JUMP:
            addi $r10, $r10, -1                 # decrement counter
            addi $bkg, $bkg, -160               # move background up by one pixel
            ren     sp2, $s2_x, $s2_y, $r0      # render sp2
            ren     bkg, $r0, $r0, $bkg         # render bkg
            j EXIT

EXIT:
    nop
    nop
    j EXIT