# Supported Instructions for RV32IM Single-Cycle CPU

This CPU core implements the full RV32I base instruction set and the RV32M extension for integer multiplication and division as defined by the RISC-V specification.

---

## RV32I Base Instructions

### Arithmetic Instructions
- `ADD`   – Add
- `SUB`   – Subtract
- `ADDI`  – Add Immediate
- `LUI`   – Load Upper Immediate
- `AUIPC` – Add Upper Immediate to PC

### Logical Instructions
- `AND`   – Bitwise AND
- `OR`    – Bitwise OR
- `XOR`   – Bitwise XOR
- `ANDI`  – Bitwise AND Immediate
- `ORI`   – Bitwise OR Immediate
- `XORI`  – Bitwise XOR Immediate

### Shift Instructions
- `SLL`   – Shift Left Logical
- `SRL`   – Shift Right Logical
- `SRA`   – Shift Right Arithmetic
- `SLLI`  – Shift Left Logical Immediate
- `SRLI`  – Shift Right Logical Immediate
- `SRAI`  – Shift Right Arithmetic Immediate

### Comparison Instructions
- `SLT`   – Set Less Than
- `SLTU`  – Set Less Than Unsigned
- `SLTI`  – Set Less Than Immediate
- `SLTIU` – Set Less Than Immediate Unsigned

### Control Transfer Instructions
- `JAL`   – Jump and Link
- `JALR`  – Jump and Link Register
- `BEQ`   – Branch if Equal
- `BNE`   – Branch if Not Equal
- `BLT`   – Branch if Less Than
- `BGE`   – Branch if Greater or Equal
- `BLTU`  – Branch if Less Than Unsigned
- `BGEU`  – Branch if Greater or Equal Unsigned

### Memory Instructions
- `LH`    – Load Halfword
- `LW`    – Load Word
- `SH`    – Store Halfword
- `SW`    – Store Word

### System Instructions
- `CSRR` – the system CSR register

---

## RV32M Extension (Multiplication/Division)

- `MUL`    – Multiply
- `MULH`   – Multiply High (signed × signed)
- `MULHSU` – Multiply High (signed × unsigned)
- `MULHU`  – Multiply High (unsigned × unsigned)
- `DIV`    – Divide (signed)
- `DIVU`   – Divide (unsigned)
- `REM`    – Remainder (signed)
- `REMU`   – Remainder (unsigned)

---

For more details, refer to the [RISC-V ISA specification](https://riscv.org/technical/specifications/).
