nop                         # basic test of bbp

addi    $r1, $r0, 1         # $r1 = 1
addi    $r5, $r1, 20        # $r5 = 21
bbp     1, downpad          # branch to downpad if DOWN (taken)

addi    $r5, $r0, 2         # $r5 = 2 (incorrect)
addi    $r5, $r5, 2         # $r5 = 4 (incorrect)
addi    $r5, $r5, 2         # $r5 = 6 (incorrect)
addi    $r5, $r5, 2         # $r5 = 8 (incorrect)

downpad:                    # landing pad for first bbp                     
addi    $r2, $r0, 7         # $r2 = 7
bbp     0, uppad            # branch to uppad if UP (not taken)

addi    $r6, $r6, 2         # $r6 = 2 (correct)
addi    $r6, $r6, 2         # $r6 = 4 (correct)
addi    $r6, $r6, 2         # $r6 = 6 (correct)
addi    $r6, $r6, 2         # $r6 = 8 (correct)

uppad:
addi    $r3, $r0, 19        # $r3 = 19

