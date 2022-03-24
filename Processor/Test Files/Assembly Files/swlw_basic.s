nop
nop
nop
nop
nop
nop
addi    $r1, $r1, 17    # $r1 = 17
addi    $r2, $r2, 64    # $r2 = 64
nop
nop
nop
nop
nop
nop
sw      $r1, 0($r2)     # mem[64+0] = 17
nop
nop
nop
nop
nop
nop
lw      $r3, 0($r2)     # $r3 = mem[64+0] (17)
nop
nop
nop
nop
nop  