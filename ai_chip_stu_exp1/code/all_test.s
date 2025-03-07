.global __start
__start:
addi x0, x0, 0
lw x2, 4(x0)
lw x4, 8(x0)
add x1, x2, x4
addi x1, x1, -1
lw x5, 12(x0)
lw x6, 16(x0)
lw x7, 20(x0)
sub x1,x4,x2
slt x1,x4,x2
slt x1,x2,x4
sra x1, x7, x2
sltu x1, x6, x7
addi x1,x7,-3
slti x1,x4,15
srli x1,x4,2
srai x1, x6, 12
lw   x8, 24(x0)
sw   x8, 28(x0)
lw   x1, 28(x0)
sh   x8, 32(x0)
lw   x1, 32(x0)
sb   x8, 36(x0)
lw   x1, 36(x0)
lh   x1, 26(x0)
lhu  x1, 26(x0)
lb   x1, 27(x0)
lbu  x1, 27(x0)
auipc x1, 0xffff0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
__vdot_test:
lw  x1, 44(x0)
lw  x2, 56(x0)
vdot x3, x1, x2
lw  x4, 48(x0)
lw  x5, 60(x0)
vdot x6, x4, x5
lw  x7, 52(x0)
lw  x8, 64(x0)
vdot x9, x7, x8
add x3, x3, x6
add x3, x3, x9
sw  x3, 68(x0)
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
jal  x0, __start