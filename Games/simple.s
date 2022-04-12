#
# simple movement with one sprite
#
#
#
# OTHER CODE.......
# LOOP AT END
#
#
#
# start game loop set $r25 to 0
# $s1-x  $s1-y   ==  sprite1 coordinates
# $bkg  ==  addr of background
# $sp1  ==  addr of sprite1
#
###################

addi $s1-x, $r0, 50   #initialize position
addi $s1-y, $r0, 50

gameloop:
bne $r25, $r0, exit
    bbp 7, exit                    #exit if START pushed

    checkUP: 
        bbp 0, UP                  #
    checkDOWN:                     #
        bbp 1, DOWN                #
    checkLEFT:                     #handle direction buttons
        bbp 2, LEFT                #
    checkRIGHT:                    #
        bbp 3, RIGHT               #
    
    j render                       # no button pressed

    UP: 
        addi $s1-y, $r0, -1
        j render
    DOWN:
        addi $s1-y, $r0, 1
        j render
    LEFT:
        addi $s1-x, $r0, -1
        j render
    RIGHT:
        addi $s1-x, $r0, 1
        j render

    render:                        #jump here on frame end?
    ren bkg, $r0, $r0, $bkg        #render background 
    ren sp1, $s1-x, $s1-y, $sp1    #render sprite1

    j gameloop

exit:
    nop
    nop