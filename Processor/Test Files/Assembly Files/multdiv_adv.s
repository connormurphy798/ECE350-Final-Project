nop             # Values initialized using addi (positive only)
nop             # Author: Connor Murphy
nop
nop             # Multdiv with Bypassing
nop 			# Multdiv Tests
addi $3, $0, 1	# r3 = 1
addi $4, $0, 35	# r4 = 35
addi $1, $0, 3	# r1 = 3
sub $3, $0, $3	# r3 = -1
sub $4, $0, $4	# r4 = -35
addi $2, $0, 21	# r2 = 21
mul $6, $2, $1	# r6 = r2 * r1 = 63
div $7, $6, $1	# r7 = r6 / r1 = 21
mul $8, $6, $1	# r8 = r6 * r1 = 189
div $9, $7, $1	# r9 = r7 / r1 = 7