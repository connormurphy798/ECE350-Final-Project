# Efficiency Test 4: Bypassing into BEX 
nop
nop 	
nop
nop	
nop
addi $r3, $r0, 1        # r3 = 1
div $r3, $r3, $r0       # div by 0, rstatus = 5, r3 undefined
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