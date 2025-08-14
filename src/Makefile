# File names
ASM_FILE = instr.S
ELF_FILE = instr.elf
BIN_FILE = instr.bin
HEX_FILE = instr.hex
VVP_FILE = rv32im.vvp

# Tools
RISCV_AS = riscv32-unknown-elf-as
RISCV_OBJCOPY = riscv32-unknown-elf-objcopy
IVERILOG = iverilog

# Default target
all: $(HEX_FILE) $(VVP_FILE)

# Generate .hex file from .S using xxd and awk
$(HEX_FILE): $(ASM_FILE)
	$(RISCV_AS) -o $(ELF_FILE) $(ASM_FILE)
	$(RISCV_OBJCOPY) -O binary $(ELF_FILE) $(BIN_FILE)
	xxd -p -c 4 $(BIN_FILE) > temp.hex
	awk '{print substr($$1,7,2) substr($$1,5,2) substr($$1,3,2) substr($$1,1,2)}' temp.hex > $(HEX_FILE)
	rm temp.hex $(ELF_FILE) $(BIN_FILE)

# Compile Verilog files
$(VVP_FILE): *.v
	$(IVERILOG) -o $(VVP_FILE) *.v


# Clean up
clean:
	rm -f $(ELF_FILE) $(BIN_FILE) temp.hex $(HEX_FILE) $(VVP_FILE)


