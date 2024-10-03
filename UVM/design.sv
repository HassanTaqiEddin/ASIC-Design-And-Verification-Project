
module RegisterFile(readReg1, readReg2,writeReg, writeEnable, writeData, readData1, readData2, clk, reset);

	input clk,reset;
	input wire [4:0 ] readReg1, readReg2;
	input wire [4:0 ] writeReg;
	input wire [31:0] writeData;
	input wire writeEnable;
	
	output wire [31:0] readData1,readData2;
	
	
	
	
	reg [31:0] registers [0:31];
	
	integer i;
	
	// To read
	assign readData1 = registers[readReg1];
	assign readData2 = registers[readReg2];
	
	
	always @(negedge clk) begin
		if(~reset) begin
			for (i = 0; i < 32; i = i + 1) begin
            registers[i] <= 0;
			end
		end
		
		else begin
			// write on posedge of clk
			if (writeEnable) begin
				if(0==writeReg)
					registers[writeReg] <= 5'b0;
				else	 
				registers[writeReg] <= writeData;
			end
			
		end
	
	
	end



endmodule