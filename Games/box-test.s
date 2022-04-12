#
# pipeline and PC latches reset on frame change
# state register holds main menu, gameplay, or game menu
#       each has a separate loop
#       at end of each loop go to exit
#           does nop until next frame resets it
#
#
##################################################################################################################

addi $r1, $r0, 1                                    # for state 1 comparison
addi $r2, $r0, 2                                    # for state 2 comparison

beq $state, $r0, OPENING
beq $state, $r1, GAMEPLAY
beq $state, $r2, MENU



#OPENING SCREEN FOR GAME
OPENING:
    bbp 7, start_OPEN
    j OPEN_DONE

    start_OPEN:                                 # on START press
        addi $state, $r0, 1                     # switch to gameplay state
        j OPEN_DONE



    OPEN_DONE:
        #ren bkg, $r0, $r0, $bkg                # render background
        j EXIT

##################################################################################################################


#DIRECTIONAL BUTTONS CONTROL SPRITE MOVEMENT
GAMEPLAY:
    bbp 7, start_GAME
    bbp 0, up_GAME
    bbp 1, down_GAME
    bbp 2, left_GAME
    bbp 3, right_GAME

    j GAMEPLAY_DONE

    start_GAME:                                 # on START press
            addi $state, $r0, 2                 # switch to opening state
            j GAMEPLAY_DONE

    up_GAME:                                    # on UP press
            addi $s1_ybuff, $s1_y, -1           # add -1 to y coordinate of sprite 1
            addi $s1_xbuff, $s1_x, 0            # keep x the same
            j process_move

    down_GAME:                                  # on DOWN press
            addi $s1_ybuff, $s1_y, 1            # add 1 to y coordinate of sprite 1
            addi $s1_xbuff, $s1_x, 0            # keep x the same
            j process_move

    left_GAME:                                  # on LEFT press
            addi $s1_xbuff, $s1_x, -1           # add -1 to x coordinate of sprite 1
            addi $s1_ybuff, $s1_y, 0            # keep y the same
            j process_move

    right_GAME:                                 # on RIGHT press
            addi $s1_xbuff, $s1_x, 1            # add 1 to x coordinate of sprite 1
            addi $s1_ybuff, $s1_y, 0            # keep y the same
            j process_move


    process_move:
            addi $r1, $r0, 160                  # $r1 = screen width
            addi $r2, $s1_xbuff, 16             # $r2 = xbuff + 16     right edge of sprite
            addi $r3, $s1_ybuff, 16             # $r3 = ybuff + 16     bottom edge of sprite

            mul $r4, $r1, $s1_ybuff             # $r4 = ybuff * screenwidth
            addi $r5, $r4, 2560                 # $r5 = (ybuff + 16) * screenwidth  =  (ybuff * screenwidth) + (16 * screenwidth)

            #top left
            add $r6, $r4, $s1_xbuff             # $r6 = xbuff + (ybuff * screenwidth) = addr to check
            lw $r6, 0($r6)                      # $r6 = MEM[addr] = background at top left corner of sprite
            #top right
            add $r7, $r4, $r2                   # $r7 = (xbuff + 16) + (ybuff * screenwidth) = addr to check
            lw $r7, 0($r7)                      # $r7 = MEM[addr] = background at top right of sprite
            #bottom left
            add $r8, $r5, $s1_xbuff             # $r8 = xbuff + ((ybuff + 16) * screenwidth) = addr to check
            lw $r8, 0($r8)                      # $r8 = MEM[addr] = background at bottom left of sprite
            #bottom right
            add $r9, $r5, $r2                   # $r9 = (xbuff + 16) + ((ybuff + 16) * screenwidth) = addr to check
            lw $r9, 0($r9)                      # $r9 = MEM[addr] = background at bottom right of sprite


            bne $r6, $r0, GAMEPLAY_DONE         # checking corners ... if hitting wall don't update position
            bne $r7, $r0, GAMEPLAY_DONE         # |
            bne $r8, $r0, GAMEPLAY_DONE         # |
            bne $r9, $r0, GAMEPLAY_DONE         # |
            
            addi $s1_x, $s1_xbuff, 0            # replace x coord with xbuff
            addi $s1_y, $s1_ybuff, 0            # replace y coord with ybuff
            j GAMEPLAY_DONE



    GAMEPLAY_DONE:
            #ren bkg, $r0, $r0, $bkg            # render background
            #ren sp1, $s1_x, $s1_y, $sp1        # render sprite 1
            j EXIT



##################################################################################################################


#DIRECTIONAL BUTTONS DON'T CONTROL SPRITE MOVEMENT
MENU:
    bbp 7, start_MENU
    j MENU_DONE

    start_OPEN:                                 # on START press
            addi $state, $r0, 0                 # switch to opening state
            j MENU_DONE


    MENU_DONE:
            j EXIT


##################################################################################################################

EXIT:
    nop
    nop
    j EXIT                                          # loop until frame reset