

module top(clk,reset);
	input clk,reset;
	
	
	// Fetch wires
	 wire [31:0] pcOut;
	 wire [31:0] pcAdderResult;
	 wire [31:0] instMemOut;
	 
	 // Decode wires
	
	 wire [31:0] decode_pcAdderResult;
	 wire [31:0] decode_instMemOut;
	 wire [25:0] jumpAddress        = decode_instMemOut    [25:0 ];
	 wire [5:0]  opCode             = decode_instMemOut    [31:26];
	 wire [5:0]  funct              = decode_instMemOut    [5 :0 ];
	 wire [4:0]  rdAddress          = decode_instMemOut    [15:11];
	 wire [4:0]  rtAddress          = decode_instMemOut    [20:16];
	 wire [4:0]  rsAddress 			= decode_instMemOut    [25:21];
	 wire [15:0] immediateData      = decode_instMemOut    [15:0 ];
	 

	 
	 
	 
	 
	 	 
	 //Outputs of Control Unit
	 wire [1:0] RegDst    ;
	 wire 		pcsrc	  ;
	 wire 		Jump      ;
	 wire       Branch    ; 
	 wire [1:0] MemtoReg  ;
	 wire       MemReadEn ;
	 wire       MemWriteEn;
	 wire [2:0] ALUOp     ;
	 wire 		ALUSrc    ;
	 wire       RegWriteEn;
	 
	 wire equal;
	 wire [27:0] shiftedJump;
	 wire [31:0] jumpTA = {decode_pcAdderResult[31:28],shiftedJump};
	 wire [31:0] immediateExtended;
	 wire [31:0] shiftedBranch;
	 wire [31:0] mux1out;
	 wire [31:0] mux2out;
	 wire [31:0] mux3out;
	 wire [31:0] data1, data2;
	 wire [31:0] shiftAdderResult;
	 wire Mux3Sel;
	 wire flush;
	 wire orOut;
	 wire stall=0;
	 
// Execute wires	 
	
	// Control wires
	wire Ex_RegWriteEn;
	wire [1:0] Ex_MemtoReg;
	wire Ex_MemWriteEn;
	wire Ex_MemReadEn;
	wire [2:0] Ex_ALUOp;
	wire [1:0] Ex_RegDst;
	wire Ex_ALUSrc;
	
	wire [31:0] Ex_data1, Ex_data2;
	
	wire [31:0] Ex_nextpc;
	wire [31:0] Ex_immediateext;
	wire [4:0] Ex_RsAddress;
	wire [4:0] Ex_RtAddress;
	wire [4:0] Ex_RdAddress;

	
	wire [31:0] Mux4out; 
	wire [4 :0] Mux5out;
	wire [31:0] ALUOut;		 

	
	wire [1:0] forwardSelA,forwardSelB;
	wire [31:0] forwardMuxAout,forwardMuxBout;
	
// Memory wires
	
	// Control wires
	wire MEM_RegWriteEn;
	wire [1:0] MEM_MemtoReg;
	wire MEM_MemWriteEn;
	wire MEM_MemReadEn;
		

	
	wire [31:0] MEM_nextpc;
	wire [31:0] MEM_ALUOut;
	wire [31:0] MEM_data2;
	wire [4 :0] MEM_WBAddress;
	
	wire [31:0] dataMemOut;
	
	
// Write back wires
	wire WB_RegWriteEn;
	wire [1:0] WB_MemtoReg;
	
	
	wire [31:0] WB_nextpc;
	wire [31:0] WB_ALUOut;
	wire [31:0] WB_dataMemOut;
	wire [4 :0] WB_WBAddress;
	wire [31:0] Mux6out;
		
		 
// Fetch instantiation
	pcReg pc_inst(.inMux(mux3out), .reset(reset),.PcWriteEn(1'b1), .clk(clk), .outAddr(pcOut));
	adder32Bit pcadder32Bit_inst(.in1(pcOut),.in2(32'd4),.out(pcAdderResult));
	Instruction_Memory  mem_inst(.PC(pcOut), .instruction(instMemOut));
	
	IF_ID_pipe IF_ID_pipe_inst(.inpcAdderResult(pcAdderResult), .inInstruction(instMemOut) ,.outInstruction(decode_instMemOut), .outpcAdderResult(decode_pcAdderResult), .clock(clk), .reset(orOut));


	 // ControlUnit
	ControlUnit Control_inst(.opCode(opCode), .funct(funct), .aluop(ALUOp), .alusrc(ALUSrc), .regdst(RegDst), .memtoreg(MemtoReg),
				.regwrite(RegWriteEn), .memread(MemReadEn), .memwrite(MemWriteEn), .branch(Branch), .jump(Jump), .pcsrc(pcsrc));
   	
	RegisterFile RegisterFile_inst(.readReg1(rsAddress), .readReg2(rtAddress),.writeReg(WB_WBAddress), .writeEnable(WB_RegWriteEn), .writeData(Mux6out), .readData1(data1), .readData2(data2), .clk(clk), .reset(reset));
	
	shifter26 shifter26_inst(.in(jumpAddress), .out(shiftedJump));	
	
	SignExtender SignExtender_inst(.in(immediateData), .out(immediateExtended));
	
	shifter32 shifter32_inst(.in(immediateExtended), .out(shiftedBranch));
	
	adder32Bit adder32Bit_inst(.in1(decode_pcAdderResult),.in2(shiftedBranch),.out(shiftAdderResult));
	
	comparator comparator_inst(.equal(equal), .a(data1), .b(data2));
	
	assign Mux3Sel =Branch & equal; 
	assign orOut = reset & ~flush;
	
	// HZD UNIT 
	HazardDetectionUnit HazardDetectionUnit_inst(.pcsrc(pcsrc),.Mux3Sel(Mux3Sel),.flush(flush));
	
	mux2x1 mux1_inst(.X(data1), .Y(jumpTA), .s(Jump), .M(mux1out));
	mux2x1 mux2_inst(.X(pcAdderResult), .Y(shiftAdderResult), .s(Mux3Sel), .M(mux2out));
	mux2x1 mux3_inst(.X(mux2out), .Y(mux1out), .s(pcsrc), .M(mux3out));	
	
	


	ID_EX_pipe ID_EX_pipe_inst(.inRegWriteEn(RegWriteEn), .inMemtoReg(MemtoReg), .inMemWriteEn(MemWriteEn), .inMemReadEn(MemReadEn), .inALUOp(ALUOp), .inRegDst(RegDst), .inALUSrc(ALUSrc),
				.inNextPC(decode_pcAdderResult), .inreadData1(data1), .inreadData2(data2), .inimmediateExtended(immediateExtended), .inRsAddress(rsAddress), .inRtAddress(rtAddress), .inRdAddress(rdAddress),
				.outRegWriteEn(Ex_RegWriteEn), .outMemtoReg(Ex_MemtoReg), .outMemWriteEn(Ex_MemWriteEn), .outMemReadEn(Ex_MemReadEn), .outALUOp(Ex_ALUOp), .outRegDst(Ex_RegDst), .outALUSrc(Ex_ALUSrc),
				.outNextPC(Ex_nextpc), .outreadData1(Ex_data1), .outreadData2(Ex_data2), .outimmediateExtended(Ex_immediateext), .outRsAddress(Ex_RsAddress), .outRtAddress(Ex_RtAddress), .outRdAddress(Ex_RdAddress) 
				,.clock(clk), .reset(reset));
	 
	 
	 


	 
	mux4x1 forwardmuxA (.X(Ex_data1), .Y(MEM_ALUOut), .Z(Mux6out), .W(), .s(forwardSelA), .M(forwardMuxAout));
	mux4x1 forwardmuxB (.X(Ex_data2), .Y(MEM_ALUOut), .Z(Mux6out), .W(), .s(forwardSelB), .M(forwardMuxBout));
	mux2x1 mux4_inst(.X(forwardMuxBout), .Y(Ex_immediateext), .s(Ex_ALUSrc), .M(Mux4out));
	ALU ALU_inst(.A(forwardMuxAout),.B(Mux4out),.OP(Ex_ALUOp),.result(ALUOut));
	

	forwardingUnit forwardingUnit_inst(.Ex_RsAddress(Ex_RsAddress), .Ex_RtAddress(Ex_RtAddress), .MEM_WBAddress(MEM_WBAddress),.MEM_RegWriteEn(MEM_RegWriteEn),
						.WB_WBAddress(WB_WBAddress),.WB_RegWriteEn(WB_RegWriteEn),
						.forwardSelA(forwardSelA),.forwardSelB(forwardSelB),.reset(reset));
	
	mux5bit mux5_inst(.X(Ex_RtAddress), .Y(Ex_RdAddress), .Z(5'd31), .W(), .s(Ex_RegDst), .M(Mux5out)); 
	
	 
	 
	 
	 
	 
	EX_MEM_pipe EX_MEM_pipe_inst(.inRegWriteEn(Ex_RegWriteEn), .inMemtoReg(Ex_MemtoReg), .inMemWriteEn(Ex_MemWriteEn), .inMemReadEn(Ex_MemReadEn), .inpcNext(Ex_nextpc), .inAluResult(ALUOut),.inreadData2(forwardMuxBout),.inWBAddress(Mux5out),
					.outRegWriteEn(MEM_RegWriteEn), .outMemtoReg(MEM_MemtoReg), .outMemWriteEn(MEM_MemWriteEn), .outMemReadEn(MEM_MemReadEn), .outpcNext(MEM_nextpc), .outAluResult(MEM_ALUOut),.outreadData2(MEM_data2),.outWBAddress(MEM_WBAddress),
					.clock(clk), .reset(reset));
	
	
	




	dataMemory dataMemory_inst( .address(MEM_ALUOut) , .writeData(MEM_data2) , .readData(dataMemOut) , .readEn(MEM_MemReadEn) , .writeEn(MEM_MemWriteEn) , .clk(clk));





	 MEM_WB_pipe MEM_WB_pipe_inst(.inRegWriteEn(MEM_RegWriteEn), .inMemtoReg(MEM_MemtoReg), .inpcNext(MEM_nextpc),.indataMemOut(dataMemOut),.inaluResult(MEM_ALUOut),.inWBAddress(MEM_WBAddress),
						.outRegWriteEn(WB_RegWriteEn),.outMemtoReg(WB_MemtoReg), .outpcNext(WB_nextpc),.outdataMemOut(WB_dataMemOut),.outaluResult(WB_ALUOut),.outWBAddress(WB_WBAddress),
						 .clock(clk) , .reset(reset));
	

	
	
	mux4x1 mux6_inst(.X(WB_ALUOut), .Y(WB_dataMemOut), .Z(WB_nextpc), .W(), .s(WB_MemtoReg), .M(Mux6out));







endmodule 