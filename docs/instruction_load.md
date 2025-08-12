# Instruction Loading Guide for RV32IM Single Cycle CPU

This guide provides step-by-step instructions on:
- Installing the RISC-V GNU toolchain for the RV32IM CPU
- Configuring the toolchain for RV32IM
- Converting RISC-V assembly code into `$readmemh`-compatible hex format
- Storing the resulting hex file as `instr.hex` in the `src` directory

---

## 1. Installing the RISC-V GNU Toolchain

### Ubuntu / Debian

```bash
sudo apt update
sudo apt install gcc-riscv64-unknown-elf binutils-riscv64-unknown-elf
```

Or, for more control or non-Ubuntu systems, install from source:

```bash
# Install dependencies
sudo apt install autoconf automake autotools-dev curl python3 libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev

# Clone the riscv-gnu-toolchain
git clone --recursive https://github.com/riscv/riscv-gnu-toolchain
cd riscv-gnu-toolchain

# Build for rv32im
./configure --prefix=/opt/riscv --with-arch=rv32im --with-abi=ilp32
make
sudo make install
```

Add the toolchain to your PATH:
```bash
export PATH=/opt/riscv/bin:$PATH
```

**Note:** You may need to adjust the prefix or toolchain path as per your installation.

---

## 2. Configuring the Toolchain for RV32IM

When assembling and compiling, always specify the correct architecture and ABI:

- Architecture: `rv32im`
- ABI: `ilp32`

For example, to assemble an assembly file (`program.s`):

```bash
riscv32-unknown-elf-as -march=rv32im -mabi=ilp32 -o program.o program.s
riscv32-unknown-elf-objcopy -O binary program.o program.bin
```

---

## 3. Converting Assembly Output to `$readmemh`-Compatible Hex

### Step 1: Assemble and Link

If you start from C code, compile with:
```bash
riscv32-unknown-elf-gcc -march=rv32im -mabi=ilp32 -nostdlib -T linker.ld -o program.elf program.c
```
For assembly:
```bash
riscv32-unknown-elf-as -march=rv32im -mabi=ilp32 -o program.o program.s
riscv32-unknown-elf-ld -T linker.ld -o program.elf program.o
```
*(Create a minimal linker script `linker.ld` as needed.)*

### Step 2: Convert ELF to Raw Binary

```bash
riscv32-unknown-elf-objcopy -O binary program.elf program.bin
```

### Step 3: Convert Binary to Hex (`$readmemh` Format)

You can use `xxd`, `hexdump`, or a simple Python script. For 32-bit words (8 hex chars per line):

#### Using `xxd`:
```bash
xxd -p -c 4 program.bin | tr '[:lower:]' '[:upper:]' > instr.hex
```
- `-c 4` puts 4 bytes (8 hex chars) per line, matching a 32-bit word.


---

## 4. Place the Hex File

Move or copy your resulting `instr.hex` to the `src` directory:

```bash
mv instr.hex src/
```

Your Verilog code should load instructions with:
```verilog
$readmemh("instr.hex", mem);
```

---

## Summary of Steps

1. **Install** the RISC-V GNU toolchain for `rv32im`.
2. **Assemble and link** your source code for the RV32IM target.
3. **Convert** the ELF/executable to a raw binary, then to hex.
4. **Place** `instr.hex` in the `src` directory for your Verilog testbench or memory module.

---

### References

- [RISC-V GNU Toolchain GitHub](https://github.com/riscv/riscv-gnu-toolchain)
- [Official RISC-V Documentation](https://riscv.org/technical/specifications/)
- [Verilog `$readmemh` documentation](https://www.chipverify.com/verilog/verilog-readmemh-readmemb)

