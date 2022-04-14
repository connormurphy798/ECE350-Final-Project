#
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
# 57600 = maze background
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

    bbp 7, start_GAME
    bne $state_buff, $r0, change_to_menu
    bbp 0, up_GAME
    bbp 1, down_GAME
    bbp 2, left_GAME
    bbp 3, right_GAME

    j GAMEPLAY_DONE

    start_GAME:                                 # on START press
            addi $state_buff, $r0, 1            # put 1 into state buffer
            j GAMEPLAY_DONE

    up_GAME:                                    # on UP press
            addi $s1_ybuff, $s1_y, -1           # add -1 to y coordinate of sprite 1
            #addi $s1_xbuff, $s1_x, 0           # keep x the same
            bbp 2, left_GAME
            bbp 3, right_GAME
            j process_move

    down_GAME:                                  # on DOWN press
            addi $s1_ybuff, $s1_y, 1            # add 1 to y coordinate of sprite 1
            #addi $s1_xbuff, $s1_x, 0           # keep x the same
            bbp 2, left_GAME
            bbp 3, right_GAME
            j process_move

    left_GAME:                                  # on LEFT press
            addi $s1_xbuff, $s1_x, -1           # add -1 to x coordinate of sprite 1
            #addi $s1_ybuff, $s1_y, 0           # keep y the same
            j process_move

    right_GAME:                                 # on RIGHT press
            addi $s1_xbuff, $s1_x, 1            # add 1 to x coordinate of sprite 1
            #addi $s1_ybuff, $s1_y, 0           # keep y the same
            j process_move


    process_move:
            addi $r1, $r0, 160                  # $r1 = screen width
            addi $r2, $s1_xbuff, 16             # $r2 = xbuff + 16     right edge of sprite
            addi $r3, $s1_ybuff, 16             # $r3 = ybuff + 16     bottom edge of sprite

            mul $r4, $s1_ybuff, $r1             # $r4 = ybuff * screenwidth
            addi $r5, $r4, 2560                 # $r5 = (ybuff + 16) * screenwidth  =  (ybuff * screenwidth) + (16 * screenwidth)

            #top left
            add $r6, $s1_xbuff, $r4             # $r6 = xbuff + (ybuff * screenwidth) = addr to check
            lw $r6, 0($r6)                      # $r6 = MEM[addr] = background at top left corner of sprite
            #top right
            add $r7, $r2, $r4                   # $r7 = (xbuff + 16) + (ybuff * screenwidth) = addr to check
            lw $r7, 0($r7)                      # $r7 = MEM[addr] = background at top right of sprite
            #bottom left
            add $r8, $s1_xbuff, $r5             # $r8 = xbuff + ((ybuff + 16) * screenwidth) = addr to check
            lw $r8, 0($r8)                      # $r8 = MEM[addr] = background at bottom left of sprite
            #bottom right
            add $r9, $r2, $r5                   # $r9 = (xbuff + 16) + ((ybuff + 16) * screenwidth) = addr to check
            lw $r9, 0($r9)                      # $r9 = MEM[addr] = background at bottom right of sprite


            bne $r6, $r0, GAMEPLAY_DONE         # checking corners ... if hitting wall don't update position
            bne $r7, $r0, GAMEPLAY_DONE         # |
            bne $r8, $r0, GAMEPLAY_DONE         # |
            bne $r9, $r0, GAMEPLAY_DONE         # |
            
            addi $s1_x, $s1_xbuff, 0            # replace x coord with xbuff
            addi $s1_y, $s1_ybuff, 0            # replace y coord with ybuff
            j GAMEPLAY_DONE


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