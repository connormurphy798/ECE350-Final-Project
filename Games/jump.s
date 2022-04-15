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


FALLING:
    bbp 2, left_FALL
    bbp 3, right_FALL
    addi $s2_ybuff, $s2_y, 160                              # try to move sprite down by 1 first
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
            addi $r1, $r1, 160                              # $r1 = screenwidth
            addi $r2, $s2_ybuff, 16                         # $r2 = y val of bottom edge of sprite
            mul $r3, $r1, $r2                               # $r3 = (y + 16) * screenwidth
            addi $r4, $s2_x, 16                             # $r4 = x + 16


            addi $r7, $r0, 2         #check 2 more pixels
            check_fall:                                     # check moving 1 first, then 2, then 3
                #bottom left
                add $r5, $s2_x, $r3                         # $r5 = x + (y+16 * screenwidth)
                add $r5, $r5, $bkg                          # $r5 = offset from background
                lw $r5, 0($r5)
                #bottom right
                add $r6, $r4, $r3                           # $r6 = x+16 + (y+16 * screenwidth)
                add $r6, $r6, $bkg                          # $r6 = offset from background
                lw $r6, 0($r6)

                bne $r5, $r0, change_to_grounded            # checking bottom corner collision...
                bne $r6, $r0, change_to_grounded            # |

                add $r3, $r3, $r1                           # add another screenwith to check another y value lower
                addi $s2_y, $s2_y, 1                        # move sprite down by 1

                addi $r7, $r7, -1                           # decrement counter by 1
                bne $r7, $r0, check_fall                    # loop until $r7 is 0

            j FALL_DONE

    change_to_grounded:
            addi $state, $r0, 3                             # change to grounded state
            j FALL_DONE


    FALL_DONE:
            ren s2, $s2_x, $s2_y, $sp2
            ren bkg, $r0, $r0, $bkg
            j EXIT


##################################################################################################################

GROUNDED:
    bbp 2, left_GROUND
    bbp 3, right_GROUND

    j process_ground

    left_GROUND:
            addi $s2_x, $s2_x, -2
            #addi $sp2, SET LEFT FACING SPRITE
            j process_ground

    right_GROUND:
            addi $s2_x, $s2_x, 2
            #addi $sp2, SET RIGHT FACING SPRITE
            j process_ground

    process_ground:
            addi $r1, $r1, 160                              # $r1 = screenwidth
            addi $r2, $s2_y, 17                             # $r2 = y val of one below sprite
            mul $r3, $r1, $r2                               # $r3 = (y + 16) * screenwidth
            addi $r4, $s2_x, 16                             # $r4 = x + 16

            #bottom left
            add $r5, $s2_x, $r3                             # $r5 = x + (y+17 * screenwidth)
            add $r5, $r5, $bkg                              # $r5 = offset from background
            lw $r5, 0($r5)
            #bottom right
            add $r6, $r4, $r3                               # $r6 = x+16 + (y+17 * screenwidth)
            add $r6, $r6, $bkg                              # $r6 = offset from background
            lw $r6, 0($r6)

            bne $r5, $r0, GROUND_DONE                       # if either corner has ground below it, continue grounded
            bne $r6, $r0, GROUND_DONE                       # |

            addi $state, $r0, 1                             # change to falling state
            j GROUND_DONE

    GROUND_DONE:
            ren s2, $s2_x, $s2_y, $sp2
            ren bkg, $r0, $r0, $bkg
            j EXIT


##################################################################################################################

JUMPING:






EXIT:
    nop
    nop
    j EXIT