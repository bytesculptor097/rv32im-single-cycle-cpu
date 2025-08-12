# Project Configuration
TOP             := core
VERILOG_FILE    := core.v cu.v alu.v alu_control.v data_mem.v decode.v imem.v pc.v reg_file.v uart_tx.v csr.v
PCF_FILE        := VSDSquadronFM
BOARD_FREQ      := 1.4
CPU_FREQ        := 20
FPGA_VARIANT    := up5k
FPGA_PACKAGE    := sg48

# UART Configuration
PICO_DEVICE     := /dev/ttyUSB0
BAUDS           := 115200

# Assembly Source
ASM_FILE        := instr.S
ELF_FILE        := instr.elf
BIN_FILE        := instr.bin
HEX_FILE        := instr.hex

# Toolchain
RISCV_AS        := riscv32-unknown-elf-as
RISCV_OBJCOPY   := riscv32-unknown-elf-objcopy

# Default target
all: $(HEX_FILE) build
	@echo "🎯 All steps completed. Bitstream ready: $(TOP).bin"

# Generate .hex file from .S using xxd and awk
$(HEX_FILE): $(ASM_FILE)
	@echo "🧾 Assembling $(ASM_FILE) to ELF..."
	@$(RISCV_AS) -o $(ELF_FILE) $(ASM_FILE)
	@echo "📤 Converting ELF to raw binary..."
	@$(RISCV_OBJCOPY) -O binary $(ELF_FILE) $(BIN_FILE)
	@echo "🔄 Converting binary to hex using xxd..."
	@xxd -p -c 4 $(BIN_FILE) > temp.hex
	@echo "🔁 Reversing byte order for little-endian format..."
	@awk '{print substr($$1,7,2) substr($$1,5,2) substr($$1,3,2) substr($$1,1,2)}' temp.hex > $(HEX_FILE)
	@rm temp.hex
	@rm $(ELF_FILE)
	@rm $(BIN_FILE)
	@echo "✅ Memory file generated: $(HEX_FILE)"

# Build Flow
build:
	@echo "🔧 Synthesizing Verilog with Yosys..."
	@yosys -DCPU_FREQ=$(CPU_FREQ) -q -p "synth_ice40 -abc9 -device u -dsp -top $(TOP) -json $(TOP).json" $(VERILOG_FILE)
	@echo "📐 Running place and route with nextpnr..."
	@nextpnr-ice40 --force --json $(TOP).json --pcf $(PCF_FILE).pcf --asc $(TOP).asc --freq $(BOARD_FREQ) --$(FPGA_VARIANT) --package $(FPGA_PACKAGE) --opt-timing -q
	@echo "⏱️  Timing analysis with icetime..."
	@icetime -p $(PCF_FILE).pcf -P $(FPGA_PACKAGE) -r $(TOP).timings -d $(FPGA_VARIANT) -t $(TOP).asc
	@echo "📦 Packing bitstream with icepack..."
	@icepack -s $(TOP).asc $(TOP).bin
	@echo "✅ Build complete: $(TOP).bin generated."

# Flash to FPGA
flash:
	@echo "🚀 Flashing bitstream to FPGA..."
	@iceprog $(TOP).bin
	@echo "✅ Flash complete."

# Clean build artifacts
clean:
	@echo "🧹 Cleaning build files..."
	@rm -rf $(TOP).blif $(TOP).asc $(TOP).bin $(TOP).json $(TOP).timings $(ELF_FILE) $(BIN_FILE) $(HEX_FILE)
	@echo "✅ Clean complete."

# UART Terminal
terminal:
	@echo "🔌 Opening UART terminal on $(PICO_DEVICE)..."
	@sudo picocom -b $(BAUDS) $(PICO_DEVICE) --imap lfcrlf,crcrlf --omap delbs,crlf --send-cmd "ascii-xfr -s -l 30 -n"

