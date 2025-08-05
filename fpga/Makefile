# Project configuration
TOP = top
PCF_FILE = VSDSquadronFM
BOARD_FREQ = 1.4
CPU_FREQ = 20
FPGA_VARIANT = up5k
FPGA_PACKAGE = sg48
VERILOG_FILES = top.v cu.v alu.v alu_control.v data_mem.v decode.v imem.v pc.v reg_file.v uart_tx.v csr.v 

# UART configuration
PICO_DEVICE = /dev/ttyUSB0
BAUDS = 115200

# Build FPGA bitstream
build:
	yosys -DCPU_FREQ=$(CPU_FREQ) -q -p "synth_ice40 -abc9 -device u -dsp -top $(TOP) -json $(TOP).json" $(VERILOG_FILES)
	nextpnr-ice40 --force --json $(TOP).json --pcf $(PCF_FILE).pcf --asc $(TOP).asc --freq $(BOARD_FREQ) --$(FPGA_VARIANT) --package $(FPGA_PACKAGE) --opt-timing -q
	icetime -p $(PCF_FILE).pcf -P $(FPGA_PACKAGE) -r $(TOP).timings -d $(FPGA_VARIANT) -t $(TOP).asc
	icepack -s $(TOP).asc $(TOP).bin

# Flash bitstream to board
flash:
	iceprog $(TOP).bin

# Clean build artifacts
clean:
	rm -rf $(TOP).blif $(TOP).asc $(TOP).bin $(TOP).json $(TOP).timings

# Open UART terminal session
terminal:
	sudo picocom -b $(BAUDS) $(PICO_DEVICE) --imap lfcrlf,crcrlf --omap delbs,crlf --send-cmd "ascii-xfr -s -l 30 -n"

# Pull latest code and rebuild
cycle:
	git pull
	make
	sudo make flash

