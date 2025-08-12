    .section .text
    .globl _start

_start:
    addi x5, x0, 31    # x5 = 31
    addi x6, x0, 6.    # x6 = 6
    mul x3, x5, x6     # x3 = x5 * x6
    div x4, x5, x6     # x4 = x5 / x6
    rem x7, x5, x6     # x7 = x5 % x6

