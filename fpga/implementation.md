# VSDSquadronFM implementation
The [VSDSquadron FPGA Mini](https://www.vlsisystemdesign.com/vsdsquadronfm/) (FM) is a compact and low-cost development board designed for FPGA prototyping and embedded system projects. This board provides a seamless hardware development experience with an integrated programmer, versatile GPIO access, and onboard memory, making it ideal for students, hobbyists, and developers exploring FPGA-based designs.
## Prerequisites

- Linux background or [virtual box](https://www.oracle.com/virtualization/technologies/vm/downloads/virtualbox-downloads.html) OSs that supports Linux (like Ubuntu)
- VSDSquadronFM

## Downloading the necessary building tools

#### Icestorm tools (icepack, icebox, iceprog, icetime, chip databases)
Install them by just running in the linux based terminal:-
```
git clone https://github.com/YosysHQ/icestorm.git icestorm
cd icestorm
make -j$(nproc)
sudo make install
```

#### NextPNR
```
git clone --recursive https://github.com/YosysHQ/nextpnr nextpnr
cd nextpnr
cmake -DARCH=ice40 -DCMAKE_INSTALL_PREFIX=/usr/local .
make -j$(nproc)
sudo make install
```
#### Yosys

```
 git clone https://github.com/YosysHQ/yosys.git yosys
 cd yosys
 make -j$(nproc)
 sudo make install
```
### Building the the binaries

Go to the `fpga` folder (Remember to clone this repository) and type in the terminal:-
```
make build
```
*This will generate the binary file like top.bin, top.asc etc.*
### Flashing to the FPGA
Then right after building binaries, type:-
```
sudo make flash
```
*This will flash the binary files to the FPGA*

### Observing the output

After flashing type:-
```
sudo make terminal
```
### OR use an application serial monitor (PuTTY)
1. Go to device  manager (in windows) and click on COM & LPT and observe the COM port for the  FTDI chip.
2. Type the COM number (in my case it is 4)
<img width="453" height="422" alt="image" src="https://github.com/user-attachments/assets/d8154722-5c83-4f3f-890c-9194c23e3b97" />

3. **Type the baud rate 115200**
4. Click on open 
<img width="400" height="286" alt="Screenshot 2025-08-03 183237" src="https://github.com/user-attachments/assets/1dbd42a5-e072-476c-a7fc-8f9cb3a4bf24" />

*This output because the current loaded instruction is for verifying the M extension of the CPU by calculating MUL, DIV and REM* 

## Observing output in hardware

Connect the VSDSquadronFM pins as:-

### 🔧 Signal Mapping Table

| Signal     | Source Object | Source Pin | Destination Object | LED     | Polarity |
|------------|----------------|-------------|---------------------|---------|----------|
| rst        | FPGA           | 3           | —                   | —       | —        |
| result[0]  | FPGA           | 42          | LED                 | LED0    | Anode    |
| result[1]  | FPGA           | 43          | LED                 | LED1    | Anode    |
| result[2]  | FPGA           | 44          | LED                 | LED2    | Anode    |
| result[3]  | FPGA           | 45          | LED                 | LED3    | Anode    |
| result[4]  | FPGA           | 46          | LED                 | LED4    | Anode    |
| result[5]  | FPGA           | 47          | LED                 | LED5    | Anode    |
| result[6]  | FPGA           | 48          | LED                 | LED6    | Anode    |
| result[7]  | FPGA           | 2           | LED                 | LED7    | Anode    |
| uarttx     | FPGA           | 14          | —                   | —       | —        |

<img width="1280" height="960" alt="image" src="https://github.com/user-attachments/assets/40fe6093-6988-40f2-a69d-a65180099856" />

*15 × 4 = 60 = 00111100* 





