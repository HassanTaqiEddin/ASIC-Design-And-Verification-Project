

module EX_MEM_pipe (inRegWriteEn, inMemtoReg, inMemWriteEn, inMemReadEn, inpcNext, inAluResult,inreadData2,inWBAddress,
					outRegWriteEn, outMemtoReg, outMemWriteEn, outMemReadEn, outpcNext, outAluResult,outreadData2,outWBAddress,
					clock, reset);
					
	// clock and reset
	input clock, reset;

	// Writeback 
	input wire inRegWriteEn;
	input wire [1:0] inMemtoReg;
	
	// memory
	input wire inMemWriteEn;
	input wire inMemReadEn;
	
	input wire [31:0] inpcNext;
	
	input wire [31:0] inAluResult;
	input wire [31:0] inreadData2;
	input wire [4 :0] inWBAddress;
	

	

	// Writeback 
	output reg outRegWriteEn;
	output reg [1:0] outMemtoReg;
	
	// memory
	output reg outMemWriteEn;
	output reg outMemReadEn;
	
	output reg [31:0] outpcNext;
	
	output reg [31:0] outAluResult;
	output reg [31:0] outreadData2;
	output reg [4 :0] outWBAddress;
	
	always @ (posedge clock or negedge reset)
	begin
		if(!reset)
		begin
			outRegWriteEn <= 1'b0;
			outMemtoReg   <= 2'b0;
			outMemWriteEn <= 1'b0;
			outMemReadEn  <= 1'b0;
			outpcNext 	  <= 32'b0;
			outreadData2  <= 5'b0;
			outAluResult  <= 32'b0;
			outWBAddress  <= 5'b0;
		end
		
		else 
		begin
			outRegWriteEn <= inRegWriteEn;
			outMemtoReg   <= inMemtoReg;
			outMemWriteEn <= inMemWriteEn;
			outMemReadEn  <= inMemReadEn;
			outpcNext 	  <= inpcNext;
			outreadData2  <= inreadData2;
			outAluResult  <= inAluResult;
			outWBAddress  <= inWBAddress;
		end
		
	end
	
endmodule 