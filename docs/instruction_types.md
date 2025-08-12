# Supported Instructions for RV32IM Single-Cycle CPU

This CPU core implements the full RV32I base instruction set and the RV32M extension for integer multiplication and division as defined by the RISC-V specification.  
Additional comparison, control transfer, memory, system, and pseudo-instructions are also listed for completeness.

---

## RV32I Base Instructions

### Arithmetic Instructions
- `ADD`    – Add
- `SUB`    – Subtract
- `ADDI`   – Add Immediate

### Logical Instructions
- `AND`    – Bitwise AND
- `OR`     – Bitwise OR
- `XOR`    – Bitwise XOR
- `ANDI`   – Bitwise AND Immediate
- `ORI`    – Bitwise OR Immediate
- `XORI`   – Bitwise XOR Immediate

### Shift Instructions
- `SLL`    – Shift Left Logical
- `SRL`    – Shift Right Logical
- `SRA`    – Shift Right Arithmetic
- `SLLI`   – Shift Left Logical Immediate
- `SRLI`   – Shift Right Logical Immediate
- `SRAI`   – Shift Right Arithmetic Immediate

### Comparison Instructions
- `SLT`    – Set Less Than (signed)
- `SLTU`   – Set Less Than Unsigned
- `SLTI`   – Set Less Than Immediate (signed)
- `SLTIU`  – Set Less Than Immediate Unsigned

### Control Transfer Instructions
- `JAL`    – Jump and Link
- `JALR`   – Jump and Link Register
- `BEQ`    – Branch if Equal
- `BNE`    – Branch if Not Equal
- `BLT`    – Branch if Less Than
- `BGE`    – Branch if Greater or Equal


### Memory Instructions
- `LW`     – Load Word
- `SW`     – Store Word



---

## RV32M Extension (Multiplication/Division)

- `MUL`    – Multiply
- `DIV`    – Divide (signed)
- `DIVU`   – Divide (unsigned)
- `REM`    – Remainder (signed)
- `REMU`   – Remainder (unsigned)


---

