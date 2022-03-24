nop 	# simple beq test case
nop 
nop 
nop
nop
nop
addi    $r1, $r0, 4     # $r1 = 4
addi    $r2, $r0, 5     # $r2 = 5
addi    $r5, $r2, 0     # $r5 = 5
nop
nop
sub     $r3, $r0, $r1   # $r3 = -4
sub     $r4, $r0, $r2   # $r4 = -5
nop
nop
nop 	
beq 	$r1, $r2, b1	# $r1 != $r2 --> not taken
addi 	$r20, $r20, 1	# $r20 += 1 (Correct)
addi 	$r20, $r20, 1	# $r20 += 1 (Correct)
addi 	$r20, $r20, 1	# $r20 += 1 (Correct)
b1: 
addi 	$r10, $r10, 1	# $r10 += 1 (Correct)
beq 	$r2, $r5, b2	# r2 == r5 --> taken
nop			# nop in case of flush
nop			# nop in case of flush
nop			# Spacer
addi 	$r10, $r10, 1	# r10 += 1 (Incorrect) 
b2: 
nop			# Landing pad for branch
nop			# Avoid add RAW hazard
nop
# final: $r10 should be 1, $r20 should be 3