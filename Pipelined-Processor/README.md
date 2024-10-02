# MIPS Pipelined Processor
The Pipelined Processor is an advanced architecture designed to improve instruction throughput by overlapping the execution of multiple instructions. This architecture employs a series of stages—such as instruction fetch, decode, execute, memory access, and write-back allowing different instructions to be processed simultaneously at different stages. This parallelism enhances performance and efficiency, enabling the processor to achieve higher clock speeds and execute more instructions per cycle. Key features include hazard detection mechanisms and support for forwarding, ensuring smooth data flow and minimizing stalls in the pipeline.


## Note: 
### This Processor is used DE10-Lite FPGA, however the project has more than top module, one for FPGA (top_fpga) and other for simulation (top), change between them if you want to test (Emulation or Simulation).
### Used tools are Quartus, Modelsim.
