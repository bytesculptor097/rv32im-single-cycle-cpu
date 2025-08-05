# VSDSquadronFM implementation
The VSDSquadron FPGA Mini (FM) is a compact and low-cost development board designed for FPGA prototyping and embedded system projects. This board provides a seamless hardware development experience with an integrated programmer, versatile GPIO access, and onboard memory, making it ideal for students, hobbyists, and developers exploring FPGA-based designs. [source](https://www.vlsisystemdesign.com/vsdsquadronfm/)
## Prerequisites

- Linux background or virtual box OSs (like Ubuntu)
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

Go to the `src` folder (Remember to clone this repository) and type in the terminal:-
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
**OR** go to an application based serial monitor like [PuTTY](https://www.putty.org/).

<img width="400" height="286" alt="Screenshot 2025-08-03 183237" src="https://github.com/user-attachments/assets/1dbd42a5-e072-476c-a7fc-8f9cb3a4bf24" />

*This output because the current loaded instruction is for verifying the M extension of the CPU by calculating MUL, DIV and REM* 



