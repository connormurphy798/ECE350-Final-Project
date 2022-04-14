#
# pipeline and PC latches reset on frame change
# state register holds main menu, gameplay, or game menu
#       each has a separate loop
#       at end of each loop go to exit
#           does nop until next frame resets it
#
#
# START SWITCHES BETWEEN OPENING AND GAMEPLAY SECTIONS
#
#############################################################

addi $r1, $r0, 1                            # for state 1 comparison
addi $r2, $r0, 2                            # for state 2 comparison

beq $state, $r0, OPENING
beq $state, $r1, GAMEPLAY
beq $state, $r2, MENU


          #OPENING SCREEN FOR GAME
OPENING:
        bbp 7, start_OPEN
        bne $r19, $r0, change_to_game
        j OPEN_DONE

        start_OPEN:                         # on START press
            addi $r19, $r0, 1               # put one in STARTbuff
            j OPEN_DONE

        change_to_game:
            addi $r19, $r0, 0               #reset STARTbuff
            addi $state, $r0, 1             #change to game state
            j OPEN_DONE



        OPEN_DONE:
            addi $bkg, $r0, 0
            ren bkg, $r0, $r0, $bkg        # render background
            j EXIT


          #DIRECTIONAL BUTTONS CONTROL SPRITE MOVEMENT
GAMEPLAY:
        bbp 7, start_GAME
        j GAME_DONE

        start_GAME:                         # on START press
            addi $state, $r0, 0             # switch to opening state
            j GAME_DONE



        GAME_DONE:
            addi $bkg, $r0, 19200
            ren bkg, $r0, $r0, $bkg         # render background
            addi $s1_x, $r0, 20
            addi $s1_y, $r0, 60
            ren sp1, $s1_x, $s1_y, $r0    # render sprite
            j EXIT


       #DIRECTIONAL BUTTONS DON'T CONTROL SPRITE MOVEMENT
MENU:

        MENU_DONE:
            j EXIT




EXIT:
    nop
    nop
    nop
    nop
    j EXIT