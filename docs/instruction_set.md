# Supported Instructions for RV32IM Single-Cycle CPU

This CPU core implements the full RV32I base instruction set and the RV32M extension for integer multiplication and division as defined by the RISC-V specification.  
Additional comparison, control transfer, memory, system, and pseudo-instructions are also listed for completeness.

---

## RV32I Base Instructions

### Arithmetic Instructions
- `ADD`    – Add
- `SUB`    – Subtract
- `ADDI`   – Add Immediate
- `LUI`    – Load Upper Immediate

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
- `BLTU`   – Branch if Less Than Unsigned
- `BGEU`   – Branch if Greater or Equal Unsigned

### Memory Instructions
- `LW`     – Load Word
- `SW`     – Store Word

### System Instructions

- `CSRRW`  – Atomic Read/Write CSR
- `CSRRS`  – Atomic Read and Set CSR bits
- `CSRRC`  – Atomic Read and Clear CSR bits
- `CSRRWI` – Atomic Read/Write CSR Immediate
- `CSRRSI` – Atomic Read and Set CSR Immediate
- `CSRRCI` – Atomic Read and Clear CSR Immediate

---

## RV32M Extension (Multiplication/Division)

- `MUL`    – Multiply
- `DIV`    – Divide (signed)
- `DIVU`   – Divide (unsigned)
- `REM`    – Remainder (signed)
- `REMU`   – Remainder (unsigned)


---

## Instruction Memory Initialization (`imem.mem`)

To run your RISC-V program on this CPU, you must initialize the instruction memory by providing a hex file named `imem.mem`.  
This file should contain the machine code (hexadecimal format) for your program, with each line representing a 32-bit instruction.

**How to initialize:**

1. **Create your RISC-V program** in assembly or C, and compile it using a RISC-V toolchain to obtain the binary/hex instructions.
2. **Convert the binary to hexadecimal** in the format expected by the simulator (one instruction per line, little-endian order if required).
3. **Place your hex instructions in `imem.mem`** within your project directory (usually under `/src` or `/sim`).

**Example `imem.mem` file:**
```
00000293  # addi x5, x0, 0
00430313  # addi x6, x6, 4
00532023  # sw x5, 0(x6)
00008067  # ret
```

**Note:**  
- Comments can be added after the instruction for clarity, but the simulator may ignore them.
- The initialization file should match the address mapping and memory size of your implementation.

**Usage in simulation:**
- During simulation, the CPU loads instructions from `imem.mem` at startup.
- Modify `imem.mem` to change the program executed by the CPU. Go to this [converter](https://luplab.gitlab.io/rvcodecjs/) to convert the assembly code to hex format. 

For more details, refer to the [RISC-V ISA specification](https://riscv.org/technical/specifications/).
