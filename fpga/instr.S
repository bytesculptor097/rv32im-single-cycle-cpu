    .section .text
    .globl _start

_start:
    mul x3, x5, x6     # x3 = x5 * x6
    div x4, x5, x6     # x4 = x5 / x6
    rem x7, x5, x6     # x7 = x5 % x6

