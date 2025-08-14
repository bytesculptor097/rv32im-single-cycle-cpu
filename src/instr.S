    .section .text
    .globl _start

_start:
    li x5, 1          # x5 = counter (starts at 1)
    li x4, 0          # x4 = sum (starts at 0)

loop:
    add x4, x4, x5    # x4 += x5
    addi x5, x5, 1    # x5 += 1
    li x6, 10         # x6 = 10 (loop limit)
    blt x5, x6, loop  # if x5 < 10, repeat loop

    # Exit (for simulation)
    li a0, 0          # exit code
    li a7, 93         # syscall for exit
    ecall
