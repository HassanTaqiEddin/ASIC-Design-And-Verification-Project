# MIPS Pipelined Processor
The Pipelined Processor is an advanced architecture designed to improve instruction throughput by overlapping the execution of multiple instructions. This architecture employs a series of stages—such as instruction fetch, decode, execute, memory access, and write-back allowing different instructions to be processed simultaneously at different stages. This parallelism enhances performance and efficiency, enabling the processor to achieve higher clock speeds and execute more instructions per cycle. Key features include hazard detection mechanisms and support for forwarding, ensuring smooth data flow and minimizing stalls in the pipeline.

## Note:
### This Processor is used DE10-Lite FPGA, however the project has more than top module, one for FPGA (top_fpga) and other for simulation (top), change between them if you want to test (Emulation or Simulation).                                                                                               Used tools are Quartus, Modelsim.

### Here is the full analysis table for control unit
<div style="text-align: center;">
  <img src="https://github.com/user-attachments/assets/c5ba3dab-7b87-473f-ba60-36c881a562d0" alt="Control Unit Analysis Table">
</div>

### Check the full datapath without Hazards
<div style="text-align: center;">
  <img src="https://github.com/user-attachments/assets/5f9cf8c4-e9ed-4964-812b-b4f686602584" alt="Datapath without Hazards">
</div>

### Forwarding Handle
<div style="text-align: center;">
  <img src="https://github.com/user-attachments/assets/f319d125-ae26-48a7-a330-17fead41694f" alt="Forwarding Handle">
</div>

### Hazard Detection Handle
<div style="text-align: center;">
  <img src="https://github.com/user-attachments/assets/03a3c37a-d475-4281-ba70-8ee96a3f49bf" alt="Hazard Detection Handle">
</div>

