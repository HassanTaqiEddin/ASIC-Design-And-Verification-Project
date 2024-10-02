



module ControlUnit(opCode, funct, aluop, alusrc, regdst, memtoreg,
				regwrite ,memread, memwrite, branch, jump, pcsrc);
	
	input [5:0] opCode;
	input [5:0] funct;
	
	
	output reg [2:0] aluop;
	output reg alusrc;
	output reg [1:0] regdst;
	output reg [1:0] memtoreg;
	output reg regwrite;
	output reg memread;
	output reg memwrite;
	output reg branch;
	output reg jump;
	output reg pcsrc;
	
	 // Function field for R type
 parameter orFunct  = 6'b000000 , andFunct = 6'b000001, xorFunct = 6'b000010,
		   addFunct = 6'b000011 , norFunct = 6'b000100, nandFunct =6'b000101,
		   sltFunct = 6'b000110 , subFunct = 6'b000111, JRFunct = 6'b001000;


 // opcodes for all instructio, note that all R type instructions have the same opCode = 0
 parameter  _rType = 6'b000000, _andi = 6'b010001, _ori   = 6'b010000, _addi = 6'b010011,	
			_xori  = 6'b010010, _nori = 6'b010100, _nandi = 6'b010101, _slti = 6'b010110,
			_subi  = 6'b010111, _lw   = 6'b100011, _sw    = 6'b101011, _beq  = 6'b110000,
			_j	   = 6'b110001, _jal  = 6'b110011;
		
			
	always @ (*) begin
	case (opCode)

			// R type instructions
			_rType : begin
				alusrc <=1'b0;
				regdst <= 2'b01;
				memtoreg <=2'b00;
				memread <=1'b0;
				memwrite <=0;
				branch <=1'b0;
				jump <=1'b0;
				
				case(funct)
					orFunct: begin
						aluop <=3'b000;
						regwrite <=1'b1;
						pcsrc <=1'b0;
					end
					
					andFunct : begin
						aluop <=3'b001;
						regwrite <=1'b1;
						pcsrc <=1'b0;
					end
					
					
					xorFunct : begin
						aluop <=3'b010;
						regwrite <=1'b1;
						pcsrc <=1'b0;
					end
					
					addFunct : begin
						aluop <=3'b011;
						regwrite <=1'b1;
						pcsrc <=1'b0;
					end			

					norFunct : begin
						aluop <=3'b100;
						regwrite <=1'b1;
						pcsrc <=1'b0;
					end

					nandFunct : begin
						aluop <=3'b101;
						regwrite <=1'b1;
						pcsrc <=1'b0;
					end
					
					sltFunct: begin
						aluop <=3'b110;
						regwrite <=1'b1;
						pcsrc <=1'b0;
					end

					subFunct: begin
						aluop <=3'b111;
						regwrite <=1'b1;
						pcsrc <=1'b0;
					end
					
					JRFunct: begin
						aluop <=3'bxxx;
						regwrite <=1'b0;
						pcsrc <=1'b1;
						end
					
					default: begin
					aluop <=3'b000;
					regwrite <=1'b0;
					pcsrc <=1'b0;
					end
				endcase
				
			end	
				_ori: begin
				aluop <=3'b000;
				alusrc <=1'b1;
				regdst <= 2'b00;
				memtoreg <=2'b00;
				regwrite <=1'b1;
				memread <=1'b0;
				memwrite <= 1'b0;
				branch <=1'b0;
				jump <=1'b0;
				pcsrc <=1'b0;
				end
				
				_andi: begin
				aluop <=3'b001;
				alusrc <=1'b1;
				regdst <= 2'b00;
				memtoreg <=2'b00;
				regwrite <=1'b1;
				memread <=1'b0;
				memwrite <= 1'b0;
				branch <=1'b0;
				jump <=1'b0;
				pcsrc <=1'b0;
				end
				
				_xori: begin
				aluop <=3'b010;
				alusrc <=1'b1;
				regdst <= 2'b00;
				memtoreg <=2'b00;
				regwrite <=1'b1;
				memread <=1'b0;
				memwrite <= 1'b0;
				branch <=1'b0;
				jump <=1'b0;
				pcsrc <=1'b0;				
				end
				
				_addi: begin
				aluop <=3'b011;
				alusrc <=1'b1;
				regdst <= 2'b00;
				memtoreg <=2'b00;
				regwrite <=1'b1;
				memread <=1'b0;
				memwrite <= 1'b0;
				branch <=1'b0;
				jump <=1'b0;
				pcsrc <=1'b0;	
				end
				
				_nori: begin
				aluop <=3'b100;
				alusrc <=1'b1;
				regdst <= 2'b00;
				memtoreg <=2'b00;
				regwrite <=1'b1;
				memread <=1'b0;
				memwrite <= 1'b0;
				branch <=1'b0;
				jump <=1'b0;
				pcsrc <=1'b0;	
				end
				
				_nandi: begin
				aluop <=3'b101;
				alusrc <=1'b1;
				regdst <= 2'b00;
				memtoreg <=2'b00;
				regwrite <=1'b1;
				memread <=1'b0;
				memwrite <= 1'b0;
				branch <=1'b0;
				jump <=1'b0;
				pcsrc <=1'b0;	
				end
				
				_slti: begin
				aluop <=3'b110;
				alusrc <=1'b1;
				regdst <= 2'b00;
				memtoreg <=2'b00;
				regwrite <=1'b1;
				memread <=1'b0;
				memwrite <= 1'b0;
				branch <=1'b0;
				jump <=1'b0;
				pcsrc <=1'b0;	
				end
				
				_subi: begin
				aluop <=3'b111;
				alusrc <=1'b1;
				regdst <= 2'b00;
				memtoreg <=2'b00;
				regwrite <=1'b1;
				memread <=1'b0;
				memwrite <= 1'b0;
				branch <=1'b0;
				jump <=1'b0;
				pcsrc <=1'b0;	
				end
				
				_lw: begin
				aluop <=3'b011;
				alusrc <=1'b1;
				regdst <= 2'b00;
				memtoreg <=2'b01;
				regwrite <=1'b1;
				memread <=1'b1;
				memwrite <= 1'b0;
				branch <=1'b0;
				jump <=1'b0;
				pcsrc <=1'b0;	
				end
				
				_sw: begin 
				aluop <=3'b011;
				alusrc <=1'b1;
				regdst <= 2'b00;
				memtoreg <=2'bxx;
				regwrite <=1'b0;
				memread <=1'b0;
				memwrite <= 1'b1;
				branch <=1'b0;
				jump <=1'b0;
				pcsrc <=1'b0;	
				end
				
				_beq: begin
				aluop <=3'bxxx;
				alusrc <=1'b0;
				regdst <= 2'b00;
				memtoreg <=2'b00;
				regwrite <=1'b0;
				memread <=1'b0;
				memwrite <= 1'b0;
				branch <=1'b1;
				jump <=1'b0;
				pcsrc <=1'b0;
				end
				
				_j: begin
				aluop <=3'bxxx;
				alusrc <=1'b0;
				regdst <= 2'b00;
				memtoreg <=2'b00;
				regwrite <=1'b0;
				memread <=1'b0;
				memwrite <= 1'b0;
				branch <=1'b0;
				jump <=1'b1;
				pcsrc <=1'b1;
				end
				
				_jal: begin
				aluop <=3'bxxx;
				alusrc <=1'bx;
				regdst <= 2'b10;
				memtoreg <=2'b10;
				regwrite <=1'b1;
				memread <=1'b0;
				memwrite <= 1'b0;
				branch <=1'b0;
				jump <=1'b1;
				pcsrc <=1'b1;
				end
				default: begin
				aluop <=3'b000;
				alusrc <=1'b0;
				regdst <= 2'b00;
				memtoreg <=2'b00;
				regwrite <=1'b0;
				memread <=1'b0;
				memwrite <= 1'b0;
				branch <=1'b0;
				jump <=1'b0;
				pcsrc <=1'b0;
				end
			endcase
	end
	



	
endmodule			