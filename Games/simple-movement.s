#
# pipeline and PC latches reset on frame change
# state register holds main menu, gameplay, or game menu
#       each has a separate loop
#       at end of each loop go to exit
#           does nop until next frame resets it
#
#
#############################################################

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



#DIRECTIONAL BUTTONS CONTROL SPRITE MOVEMENT
GAMEPLAY:
        bbp 7, start_GAME
        bbp 0, up_GAME
        bbp 1, down_GAME
        bbp 2, left_GAME
        bbp 3, right_GAME

        j GAMEPLAY_DONE

        start_GAME:                                 # on START press
            addi $state, $r0, 0                     # switch to opening state
            j GAMEPLAY_DONE

        up_GAME:                                    # on UP press
            addi $s1_y, $s1_y, -1                   # add -1 to y coordinate of sprite 1
            j GAMEPLAY_DONE

        down_GAME:                                  # on DOWN press
            addi $s1_y, $s1_y, 1                    # add 1 to y coordinate of sprite 1
            j GAMEPLAY_DONE

        left_GAME:                                  # on LEFT press
            addi $s1_x, $s1_x, -1                   # add -1 to x coordinate of sprite 1
            j GAMEPLAY_DONE

        right_GAME:                                 # on RIGHT press
            addi $s1_x, $s1_x, 1                    # add 1 to x coordinate of sprite 1
            j GAMEPLAY_DONE



        GAMEPLAY_DONE:
            #ren bkg, $r0, $r0, $bkg                # render background
            #ren sp1, $s1_x, $s1_y, $sp1            # render sprite 1
            j EXIT



#DIRECTIONAL BUTTONS DON'T CONTROL SPRITE MOVEMENT
MENU:

        MENU_DONE:
            j EXIT




EXIT:
    nop
    nop