#
# doodle-jump-like vertical platformer
3
# pipeline and PC latches reset on frame change
# state register holds main menu, gameplay, or game menu
#       each has a separate loop
#       at end of each loop go to exit
#           does nop until next frame resets it
#
#
# BACKGROUND MEMORY LOCATIONS
# 0 = opening screen
# 19200 = pause, resume selected
# 38400 = pause, exit selected
# 57600 = start of background
##################################################################################################################

addi $r1, $r0, 1                                    # for state 1 comparison
addi $r2, $r0, 2                                    # for state 2 comparison

beq $state, $r0, OPENING                            #  OPENING = state 0
beq $state, $r1, GAMEPLAY                           # GAMEPLAY = state 1
beq $state, $r2, MENU                               #     MENU = state 2



#OPENING SCREEN FOR GAME
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

        addi $bkg, $r0, 57600                   # render game background next
        addi $sp1, $r0, 0                       # render sprite at memory 0 next

        ######## INITIALIZE SPRITE POSITION ########

        j EXIT

    OPEN_DONE:
        addi $bkg, $r0, 0                       # render opening background
        ren bkg, $r0, $r0, $bkg                 # |
        j EXIT

##################################################################################################################


#DIRECTIONAL BUTTONS CONTROL SPRITE MOVEMENT
GAMEPLAY:
    addi $s1_xbuff, $s1_x, 0                    # initialize xbuff to x
    addi $s1_ybuff, $s1_y, 0                    # initialize ybuff to y

    


    change_to_menu:
            addi $state_buff, $r0, 0            # reset state buffer
            addi $state, $r0, 2                 # change to MENU state

            ren bkg, $r0, $r0, $bkg             # render background
            ren sp1, $s1_x, $s1_y, $sp1         # render sprite 1 from memory 0

            addi $s1_xbuff, $s1_x, 0            # save x coordinate
            addi $s1_ybuff, $s1_y, 0            # save y coordinate
            addi $s1_x, $r0, 200                # put sprite off screen
            addi $s1_y, $r0, 0                  # |

            addi $bkg, $r0, 19200               # render resume selected on menu change

            j EXIT


    GAMEPLAY_DONE:
            ren bkg, $r0, $r0, $bkg             # render background
            ren sp1, $s1_x, $s1_y, $sp1         # render sprite 1 from memory 0
            j EXIT



##################################################################################################################


#DIRECTIONAL BUTTONS DON'T CONTROL SPRITE MOVEMENT
MENU:
    addi $r1, $r0, 1                            # for state_buff comparison
    addi $r2, $r0, 2                            # |

    bbp 7, start_MENU
    bbp 4, a_MENU
    beq $state_buff, $r1, menu_change_to_game
    beq $state_buff, $r2, exit_game
    bbp 2, left_MENU
    bbp 3, right_MENU
    
    j MENU_DONE

    start_MENU:                                 # on START press
            addi $state_buff, $r0, 1            # put 1 into state buffer
            j MENU_DONE

    a_MENU:                                     # on A press
            addi $r1, $r0, 38400
            beq $bkg, $r1, do_quit
            addi $state_buff, $r0, 1            # put 1 into state buffer
            j MENU_DONE

            do_quit:
                addi $state_buff, $r0, 2        # put 2 into state buffer
                j MENU_DONE

    left_MENU:                                  # on LEFT press
            addi $bkg, $r0, 19200
            j MENU_DONE

    right_MENU:                                 # on RIGHT press
            addi $bkg, $r0, 38400
            j MENU_DONE

    menu_change_to_game:
            addi $state_buff, $r0, 0            # reset state buffer
            addi $state, $r0, 1                 # change to GAMEPLAY state
            addi $s1_x, $s1_xbuff, 0            # move sprite back on screen
            addi $s1_y, $s1_ybuff, 0            # |

            ren bkg, $r0, $r0, $bkg             # render menu background

            addi $bkg, $r0, 57600               # render game background next
            j EXIT

    exit_game:
            addi $state_buff, $r0, 0            # reset state buffer
            addi $state, $r0, 1                 # go to game when returning from quit
            addi $s1_x, $s1_xbuff, 0            # move sprite back on screen
            addi $s1_y, $s1_ybuff, 0            # |
            addi $bkg, $r0, 57600               # render game background next
            nop
            nop                                 # stall to let state change get through pipeline
            nop
            nop
            nop
            QUITGAME $r0                        # quits game and keeps progress saved
            j EXIT


    MENU_DONE:
            ren bkg, $r0, $r0, $bkg             # render background
            ren sp1, $s1_x, $s1_y, $sp1         # render sprite 1 from memory 0
            j EXIT


##################################################################################################################

EXIT:
    nop
    nop
    j EXIT                                      # loop until frame reset