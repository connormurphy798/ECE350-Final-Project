# Efficiency Test 4: Bypassing into BEX 
nop
nop 	
nop
nop	
nop
addi $r1, $r0, 32767    # r1 = 32767
sll $r1, $r1, 16        # r1 = 2147418112
addi $r1, $r1, 65535    # r1 = 2147483647 (Max positive integer)
addi $r2, $r0, 2        # r2 = 2
addi $r3, $r0, 1        # r3 = 1
add $r5, $r1, $r3        # add ovfl --> rstatus = 1
bex e1				    # r30 != 0 --> taken
addi $r20, $r20, 1		# r20 += 1 (Incorrect)
addi $r20, $r20, 1		# r20 += 1 (Incorrect)
addi $r20, $r20, 1		# r20 += 1 (Incorrect)
addi $r20, $r20, 1		# r20 += 1 (Incorrect)
addi $r20, $r20, 1		# r20 += 1 (Incorrect)
e1: addi $r10, $r10, 1		# r10 += 1 (Correct)
nop
nop
nop
nop
# Final: $r10 should be 1, $r20 should be 0