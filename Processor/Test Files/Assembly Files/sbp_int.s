nop                         # test of sbp including bypassing
addi    $r1, $r0, 3         # initialize $r1 with 3

sbp     $r4, 5              # $r4 = B (1)
addi    $r5, $r4, 6         # $r5 = $r4 + 6 = 7 (MX bypass)
add     $r6, $r4, $r1       # $r6 = $r4 + $r1 = 4 (WX bypass)

sbp     $r14, 6             # $r14 = C (0)
add     $r15, $r14, $r1     # $r15 = $r14 + $r1 = 3 (MX bypass)
addi    $r16, $r14, 6       # $r16 = $r14 + 6 = 6 (WX bypass)
