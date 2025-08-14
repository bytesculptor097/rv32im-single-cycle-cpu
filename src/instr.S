    .section .text
    .globl _start

_start:
    li x1, 13         # x1 = 13
    li x2, 5           # x2 = 5  

    mul  x3, x1, x2    
    div  x4, x1, x2    
    divu x5, x1, x2    
    rem  x6, x1, x2    
    remu x7, x1, x2    

