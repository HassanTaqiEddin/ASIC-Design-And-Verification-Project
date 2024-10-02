

module ID_EX_pipe(inRegWriteEn, inMemtoReg, inMemWriteEn, inMemReadEn, inALUOp, inRegDst, inALUSrc,
				inNextPC, inreadData1, inreadData2, inimmediateExtended, inRsAddress, inRtAddress, inRdAddress,
				outRegWriteEn, outMemtoReg, outMemWriteEn, outMemReadEn, outALUOp, outRegDst, outALUSrc,
				outNextPC, outreadData1, outreadData2, outimmediateExtended, outRsAddress, outRtAddress, outRdAddress 
				,clock, reset);

	//define inputs (wires)
	
	input  clock, reset;
// Control unit signals	
	// Writeback 
	input wire inRegWriteEn;
	input wire [1:0] inMemtoReg;
	
	// memory
	input wire inMemWriteEn;
	input wire inMemReadEn;
	
	// execute
	input wire [2:0] inALUOp;
	input wire [1:0] inRegDst;
	input wire inALUSrc;
	
	
// Data wires	
	// Writeback
	input wire [31:0] inNextPC;
	
	// execute
	input wire [31:0] inreadData1,inreadData2;
	input wire [31:0] inimmediateExtended;
	input wire [4 :0] inRsAddress, inRtAddress, inRdAddress;
	
	
	
	

	//define outputs (registers)
	output reg outRegWriteEn;
	output reg [ 1:0] outMemtoReg;
	
	// memory
	output reg outMemWriteEn;
	output reg outMemReadEn;
	
	// execute
	output reg [2:0] outALUOp;
	output reg [1:0] outRegDst;
	output reg outALUSrc;
	
	
// Data wires	
	// Writeback
	output reg  [31:0] outNextPC;
	
	// execute
	output reg  [31:0] outreadData1, outreadData2;
	output reg  [31:0] outimmediateExtended;
	output reg  [4 :0] outRsAddress, outRtAddress, outRdAddress;
	
	always @ (posedge clock or negedge reset) begin
	
		if( (!reset)) begin
			outRegWriteEn    <= 1'b0;
			outMemtoReg  	 <= 2'b0 ;
			outMemWriteEn    <= 1'b0 ;
			outMemReadEn 	 <= 1'b0;
			outALUOp     	 <= 3'b0;
			outRegDst    	 <= 2'b0;
			outALUSrc   	 <= 1'b0;
			outNextPC  		 <= 5'b0 ;
			outreadData1  	 <= 5'b0 ;
			outreadData2 	 <= 5'b0 ;
			outimmediateExtended  <= 32'b0;
			outRsAddress     <= 5'b0 ;
			outRtAddress	 <= 5'b0 ;
			outRdAddress 	 <= 5'b0 ;
		end
		
		else begin
			outRegWriteEn    <= inRegWriteEn;
			outMemtoReg  	 <= inMemtoReg ;
			outMemWriteEn    <= inMemWriteEn ;
			outMemReadEn 	 <= inMemReadEn;
			outALUOp     	 <= inALUOp;
			outRegDst    	 <= inRegDst;
			outALUSrc   	 <= inALUSrc;
			outNextPC  		 <= inNextPC;
			outreadData1  	 <= inreadData1;
			outreadData2 	 <= inreadData2;
			outimmediateExtended  <= inimmediateExtended;
			outRsAddress     <= inRsAddress ;
			outRtAddress	 <= inRtAddress ;
			outRdAddress 	 <= inRdAddress ;
	end
end
endmodule 