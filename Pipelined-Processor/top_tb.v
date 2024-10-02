
`timescale 1ns/1ps

module top_tb ();

	reg [31:0] cycles = 0;
	reg [31:0] flsh = 0;
	reg [31:0] stallsNum = 0;
	reg [31:0] numOfexecuted = 0;
	reg [31:0] forwardings = 0;
	reg [31:0] branches = 0;
	reg [31:0] numOfJump = 0;
	reg [31:0] memAccess = 0;

	integer file;
	reg clock, reset;

	top processor (.clk(clock), .reset(reset));

	initial begin
		clock <= 1'b0;
		reset <= 1'b0;
		#30 reset <= 1'b1;
		file = $fopen("simulation.txt", "w");
	end

	always @(posedge clock) begin
		cycles = cycles + 1;
		#1;
		if(processor.flush)
			flsh = flsh + 1;
		if(processor.stall)
			stallsNum <= stallsNum + 1;
		if(processor.Branch)
			branches <= branches + 1;
		if(processor.Jump || (processor.opCode == 0 && processor.funct == 08))
			numOfJump <= numOfJump + 1;
		if(processor.MEM_MemWriteEn || processor.MEM_MemReadEn)
			memAccess <= memAccess + 1;
		if((processor.forwardSelA[0] || processor.forwardSelA[1] || processor.forwardSelB[0] || processor.forwardSelB[1]) && !processor.Ex_ALUSrc)
			forwardings <= forwardings + 1;
	end

	always @(*) begin
		numOfexecuted <= (cycles - 4 - flsh - stallsNum);
	end

	always @(posedge clock) begin
		// Display fetched instruction in each cycle
		$fdisplay(file, "Fetched Instruction: 0x%h at PC: 0x%h", processor.instMemOut, processor.pcOut);

		if (processor.instMemOut == 32'hffffffff) begin
			$fdisplay(file, "End of program encountered. Stopping simulation.");
			$fdisplay(file, "Number of cycles: 0x%h", cycles - 1);
			$fdisplay(file, "Number of Fluches: 0x%h", flsh);
			$fdisplay(file, "Number of stalls: 0x%h", stallsNum);
			$fdisplay(file, "Number of Executed instructions: 0x%h", numOfexecuted);
			$fdisplay(file, "Number of Forwardings: 0x%h", forwardings);
			$fdisplay(file, "Number of Branches: 0x%h", branches);
			$fdisplay(file, "Number of Jump: 0x%h", numOfJump);
			$fdisplay(file, "Number of Memory access (LW,SW): 0x%h", memAccess);
			$fdisplay(file, "Clock Frequency: 75 MHz");
			$fdisplay(file, "Clock Period: 13.3 ns");
			$fdisplay(file, "CPU Time: %0d ns", (cycles - 1) * 13.3);

			// Print final register file values
			$fdisplay(file, "Register file values:");
			$fdisplay(file, "R00: 0x%h", processor.RegisterFile_inst.registers[0]);
			$fdisplay(file, "R01: 0x%h", processor.RegisterFile_inst.registers[1]);
			$fdisplay(file, "R02: 0x%h", processor.RegisterFile_inst.registers[2]);
			$fdisplay(file, "R03: 0x%h", processor.RegisterFile_inst.registers[3]);
			$fdisplay(file, "R04: 0x%h", processor.RegisterFile_inst.registers[4]);
			$fdisplay(file, "R05: 0x%h", processor.RegisterFile_inst.registers[5]);
			$fdisplay(file, "R06: 0x%h", processor.RegisterFile_inst.registers[6]);
			$fdisplay(file, "R07: 0x%h", processor.RegisterFile_inst.registers[7]);
			$fdisplay(file, "R08: 0x%h", processor.RegisterFile_inst.registers[8]);
			$fdisplay(file, "R09: 0x%h", processor.RegisterFile_inst.registers[9]);
			$fdisplay(file, "R0A: 0x%h", processor.RegisterFile_inst.registers[10]);
			$fdisplay(file, "R0B: 0x%h", processor.RegisterFile_inst.registers[11]);
			$fdisplay(file, "R0C: 0x%h", processor.RegisterFile_inst.registers[12]);
			$fdisplay(file, "R0D: 0x%h", processor.RegisterFile_inst.registers[13]);
			$fdisplay(file, "R0E: 0x%h", processor.RegisterFile_inst.registers[14]);
			$fdisplay(file, "R0F: 0x%h", processor.RegisterFile_inst.registers[15]);
			$fdisplay(file, "R10: 0x%h", processor.RegisterFile_inst.registers[16]);
			$fdisplay(file, "R11: 0x%h", processor.RegisterFile_inst.registers[17]);
			$fdisplay(file, "R12: 0x%h", processor.RegisterFile_inst.registers[18]);
			$fdisplay(file, "R13: 0x%h", processor.RegisterFile_inst.registers[19]);
			$fdisplay(file, "R14: 0x%h", processor.RegisterFile_inst.registers[20]);
			$fdisplay(file, "R15: 0x%h", processor.RegisterFile_inst.registers[21]);
			$fdisplay(file, "R16: 0x%h", processor.RegisterFile_inst.registers[22]);
			$fdisplay(file, "R17: 0x%h", processor.RegisterFile_inst.registers[23]);
			$fdisplay(file, "R18: 0x%h", processor.RegisterFile_inst.registers[24]);
			$fdisplay(file, "R19: 0x%h", processor.RegisterFile_inst.registers[25]);
			$fdisplay(file, "R1A: 0x%h", processor.RegisterFile_inst.registers[26]);
			$fdisplay(file, "R1B: 0x%h", processor.RegisterFile_inst.registers[27]);
			$fdisplay(file, "R1C: 0x%h", processor.RegisterFile_inst.registers[28]);
			$fdisplay(file, "R1D: 0x%h", processor.RegisterFile_inst.registers[29]);
			$fdisplay(file, "R1E: 0x%h", processor.RegisterFile_inst.registers[30]);
			$fdisplay(file, "R1F: 0x%h", processor.RegisterFile_inst.registers[31]/4); // To make it word addressable as the cycle accurate

			$fclose(file);
			$display("End of program encountered. Stopping simulation.");
			$display("Number of cycles: 0x%h", cycles - 1);
			$display("Number of Fluches: 0x%h", flsh);
			$display("Number of stalls: 0x%h", stallsNum);
			$display("Number of Executed instructions: 0x%h", numOfexecuted);
			$display("Number of Forwardings: 0x%h", forwardings);
			$display("Number of Branches: 0x%h", branches);
			$display("Number of Jump: 0x%h", numOfJump);
			$display("Number of Memory access (LW,SW): 0x%h", memAccess);
			$display("Clock Frequency: 75 MHz");
			$display("Clock Period: 13.3 ns");
			$display("CPU Time: %0d ns", (cycles - 1) * 13.3);
			
			// Print final register file values
			$display("Register file values:");
			$display("R00: 0x%h", processor.RegisterFile_inst.registers[0]);
			$display("R01: 0x%h", processor.RegisterFile_inst.registers[1]);
			$display("R02: 0x%h", processor.RegisterFile_inst.registers[2]);
			$display("R03: 0x%h", processor.RegisterFile_inst.registers[3]);
			$display("R04: 0x%h", processor.RegisterFile_inst.registers[4]);
			$display("R05: 0x%h", processor.RegisterFile_inst.registers[5]);
			$display("R06: 0x%h", processor.RegisterFile_inst.registers[6]);
			$display("R07: 0x%h", processor.RegisterFile_inst.registers[7]);
			$display("R08: 0x%h", processor.RegisterFile_inst.registers[8]);
			$display("R09: 0x%h", processor.RegisterFile_inst.registers[9]);
			$display("R0A: 0x%h", processor.RegisterFile_inst.registers[10]);
			$display("R0B: 0x%h", processor.RegisterFile_inst.registers[11]);
			$display("R0C: 0x%h", processor.RegisterFile_inst.registers[12]);
			$display("R0D: 0x%h", processor.RegisterFile_inst.registers[13]);
			$display("R0E: 0x%h", processor.RegisterFile_inst.registers[14]);
			$display("R0F: 0x%h", processor.RegisterFile_inst.registers[15]);
			$display("R10: 0x%h", processor.RegisterFile_inst.registers[16]);
			$display("R11: 0x%h", processor.RegisterFile_inst.registers[17]);
			$display("R12: 0x%h", processor.RegisterFile_inst.registers[18]);
			$display("R13: 0x%h", processor.RegisterFile_inst.registers[19]);
			$display("R14: 0x%h", processor.RegisterFile_inst.registers[20]);
			$display("R15: 0x%h", processor.RegisterFile_inst.registers[21]);
			$display("R16: 0x%h", processor.RegisterFile_inst.registers[22]);
			$display("R17: 0x%h", processor.RegisterFile_inst.registers[23]);
			$display("R18: 0x%h", processor.RegisterFile_inst.registers[24]);
			$display("R19: 0x%h", processor.RegisterFile_inst.registers[25]);
			$display("R1A: 0x%h", processor.RegisterFile_inst.registers[26]);
			$display("R1B: 0x%h", processor.RegisterFile_inst.registers[27]);
			$display("R1C: 0x%h", processor.RegisterFile_inst.registers[28]);
			$display("R1D: 0x%h", processor.RegisterFile_inst.registers[29]);
			$display("R1E: 0x%h", processor.RegisterFile_inst.registers[30]);
			$display("R1F: 0x%h", processor.RegisterFile_inst.registers[31]/4);
			$stop;
		end
	end

	always begin
		#10 clock <= ~clock;
	end
	
	
	// always block for printing information
	always @(posedge clock) begin

			// for fetch stage
			
			$display("# Fetch Stage: ");
			
			// printing program counter

			// printing instruction memory outputs 
			$display("Instruction at fetched stage : 0x%h", processor.instMemOut);
			$display("PC : 0x%0h", processor.pcOut);

			$display(" ");
			
			// for decode stage
			$display("# Decode Stage:");
			
			// printing instructions
			$display("Instruction in decode stage : 0x%h", processor.decode_instMemOut);
			$display("Opcode: 0x%h",processor.opCode );
			$display("Rs: 0x%h",processor.rsAddress,"\t Rt:0x%h",processor.rtAddress,"\t Rd:0x%h",processor.rdAddress);
			$display("ReadData1: 0x%h",processor.data1,"\t ReadData2: 0x%h",processor.data2);

			$display(" ");
			
			// for execute stage 
			$display("# Execute Stage:");
			$display("ALU Operand1: 0x%h",processor.forwardMuxAout);
			$display("ALU Operand2: 0x%h",processor.Mux4out);
			$display("ALU opeartion: 0x%h",processor.Ex_ALUOp);
			$display("ALU Results: 0x%h",processor.ALUOut);

						
			$display(" ");
			
			// for memory stage 
			$display("# Memory Stage:");
			// display memory status (write)
			// for instruction 1 
			$display("instruction  Write on Memory: %s", processor.MEM_MemWriteEn ? "Yes" : "No");
			if (processor.MEM_MemWriteEn) begin
				$display ("Write on address : %h", processor.MEM_ALUOut);
				$display ("Written data : %h", processor.MEM_data2);
			end

			// display memory status (Read)
			// for instruction 1
			$display("instruction Read from Memory: %s", processor.MEM_MemReadEn ? "Yes" : "No");
			if (processor.MEM_MemReadEn)begin
				$display ("Read from address : %h", processor.MEM_ALUOut);
				$display ("data Read  : %h", processor.dataMemOut);
			end

	
			$display(" ");
			
			// for write back stage
			$display("# Write Back Stage: ");
			 
			// display register file status
			// for instruction 1
			$display("instruction Write on register file: %s", processor.WB_RegWriteEn ? "Yes" : "No");
			if (processor.WB_RegWriteEn) begin 
				$display ("Write on register number : %h", processor.WB_WBAddress);
				$display ("Value written on register : %h", processor.Mux6out);
			end


			$display("**************************************************************************************************");	
	end


endmodule