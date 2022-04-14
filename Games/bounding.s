GAMEPLAY:
    addi $s1_xbuff, $s1_x, 0                    # initialize xbuff to x
    addi $s1_ybuff, $s1_y, 0                    # initialize ybuff to y

    bbp 0, up_GAME
    bbp 1, down_GAME
    bbp 2, left_GAME
    bbp 3, right_GAME

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
            addi $r10, $r0, 80                  # bounding line down middle of screen

            addi $r1, $r0, 160                  # $r1 = screen width
            addi $r2, $s1_xbuff, 16             # $r2 = xbuff + 16     right edge of sprite
            addi $r3, $s1_ybuff, 16             # $r3 = ybuff + 16     bottom edge of sprite

            mul $r4, $s1_ybuff, $r1             # $r4 = ybuff * screenwidth
            addi $r5, $r4, 2560                 # $r5 = (ybuff + 16) * screenwidth  =  (ybuff * screenwidth) + (16 * screenwidth)

            #top left
            add $r6, $s1_xbuff, $r4             # $r6 = xbuff + (ybuff * screenwidth) = addr to check

            #top right
            add $r7, $r2, $r4                   # $r7 = (xbuff + 16) + (ybuff * screenwidth) = addr to check

            #bottom left
            add $r8, $s1_xbuff, $r5             # $r8 = xbuff + ((ybuff + 16) * screenwidth) = addr to check

            #bottom right
            add $r9, $r2, $r5                   # $r9 = (xbuff + 16) + ((ybuff + 16) * screenwidth) = addr to check



            beq $s1_xbuff, $r10, GAMEPLAY_DONE
            beq $r2, $r10, GAMEPLAY_DONE
            
            addi $s1_x, $s1_xbuff, 0            # replace x coord with xbuff
            addi $s1_y, $s1_ybuff, 0            # replace y coord with ybuff
            j GAMEPLAY_DONE



    GAMEPLAY_DONE:
            ren bkg, $r0, $r0, $bkg             # render background
            ren sp1, $s1_x, $s1_y, $sp1         # render sprite 1 from memory 0
            j EXIT


EXIT:
    nop
    nop
    j EXIT