# ASIC-Design-And-Verification-Project
Pipelined Processor, Cycle Accurate Simulator, UVM, Automation


## Overview
This project focuses on designing and verifying a MIPS pipelined processor with hazard detection and forwarding mechanisms. The work includes the development of an assembler for MIPS instruction to machine code conversion, a cycle-accurate simulator, and automated UVM testbenches for verification.

## Key Components

### Pipelined Processor
- Implements a 5-stage pipeline: Fetch, Decode, Execute, Memory, and Write-back.
- Handles hazard detection and forwarding logic.
- Designed to efficiently execute MIPS instructions.

### Cycle-Accurate Simulator
- Developed in C++ to simulate the processor’s behavior clock-by-clock.
- Includes performance metrics and instruction tracing to verify behavior.

### UVM Testbenches
- Automated testbenches created for verifying shift registers and the register file.
- Achieves 100% correctness with 80% coverage using a 100-sequence test suite.

### Error-Checking Tool
- Compares the results of the C++ cycle-accurate simulator with the Verilog simulation outputs.
- Ignores PC values based on constraints and focuses on instruction correctness.

## Features
- **Assembler:** Converts MIPS assembly code into machine code.
- **FPGA Implementation:** The processor is synthesized and tested on FPGA.
- **Hazard Handling:** Includes flush logic for control hazards (e.g., jumps).
- **Performance Metrics:** Detailed reports on processor performance.

## Setup & Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/HassanTaqiEddin/ASIC-Design-Verification-Project

