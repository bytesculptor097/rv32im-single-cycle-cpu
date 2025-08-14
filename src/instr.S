    .section .text
    .globl _start

_start:
    # x1 = -15 
    li x1, -15

    # x2 = 4 
    li x2, 4

    # MUL: -15 * 4 = -60
    mul x10, x1, x2       # x10 = -60

    # DIV: -15 / 4 = -3
    div x11, x1, x2       # x11 = -3

    # DIVU: 4294967281 / 4 = 1073741820
    divu x12, x1, x2      # x12 = 1073741820

    # REM: -15 % 4 = -3
    rem x13, x1, x2       # x13 = -3

    # REMU: 4294967281 % 4 = 1
    remu x14, x1, x2      # x14 = 1
