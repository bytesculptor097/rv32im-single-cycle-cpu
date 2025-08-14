    .section .text
    .globl _start

_start:
    # x1 = -15 
    li x1, -15

    # x7 = 4 
    li x7, 4

    # MUL: -15 * 4 = -60
    mul x2, x1, x7       # x2 = -60

    # DIV: -15 / 4 = -3
    div x3, x1, x7       # x3 = -3

    # DIVU: 4294967281 / 4 = 1073741820
    divu x4, x1, x7      # x4 = 1073741820

    # REM: -15 % 4 = -3
    rem x5, x1, x7       # x5 = -3

    # REMU: 4294967281 % 4 = 1
    remu x6, x1, x7      # x6 = 1
