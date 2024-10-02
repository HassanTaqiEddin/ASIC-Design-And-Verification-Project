
//this module for the pc register
//pc always points to the address of the next instruction to be fetched
module pcReg (inMux, reset,PcWriteEn, clk, outAddr);
 
	//inputs
	input [31:0] inMux;
	input reset, PcWriteEn , clk;
	 
	//outputs
	output [31:0] outAddr;
	
	// pc register (memory)
	reg [31:0] pc;
	 
	//update value of pc
	always @(posedge clk or negedge reset)
	begin
		if (~reset) begin//active low reset
			pc <= 0;
		end
		
		else if (PcWriteEn) begin
			pc <= inMux;
		end
	end
	 
	assign outAddr = pc;
	
endmodule
