#
# simple jump test
#
# $state = 1 = FALLING = affected by gravity, cannot jump
# $state = 3 = GROUNDED = can move and jump
# $state = 4 = JUMPING = gravity off, moving upwards for some frames, cannot jump
#
##################################################################################################################

# addi $bkg, SET INITIAL BACKGROUND POSITION


FALLING:
    bbp 2, left_FALL
    bbp 3, right_FALL
    addi $s2_ybuff, $s2_y, 160                           # try to move sprite down by 1 first
    j process_fall

    left_FALL:
            addi $s2_x, $s2_x, -2
            #addi $sp2, SET LEFT FACING SPRITE
            j process_fall

    right_FALL:
            addi $s2_x, $s2_x, 2
            #addi $sp2, SET RIGHT FACING SPRITE
            j process_fall
    

    process_fall:
            addi $r1, $r1, 160                          # $r1 = screenwidth
            addi $r2, $s2_ybuff, 16                     # $r2 = y val of bottom edge of sprite
            mul $r3, $r1, $r2                           # $r3 = (y + 16) * screenwidth
            addi $r4, $s2_x, 16                         # $r4 = x + 16

        check_fall:                                     # check moving 1 first, then 2, then 3
            #bottom left
            add $r5, $s2_x, $r3                         # $r5 = x + (y+16 * screenwidth)
            #bottom right
            add $r6, $r4, $r3                           # $r6 = x+16 + (y+16 * screenwidth)




    FALL_DONE:
            ren s2, $s2_x, $s2_y, $sp2
            ren bkg, $r0, $r0, $bkg
            j EXIT

GROUNDED:



JUMPING:






EXIT:
    nop
    nop
    j EXIT