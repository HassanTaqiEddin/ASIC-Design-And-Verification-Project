


module ALU(A,B,OP,result);


	input [31:0] A,B;
	input [2:0] OP;


	output reg [31:0] result;


	parameter Or  =3'b000,   And =3'b001, Xor =3'b010, 
			  Add =3'b011,   Nor =3'b100, Nand=3'b101,
			  Slt =3'b110,	 Sub =3'b111;
			  
			
	always @(*) begin
	case(OP)
		Or:
		result <= A|B;
		
		And:
		result <= A&B;
		
		Xor:
		result <= A^B;
		
		Add: 
		result <= A+B;
		
		Nor:
		result <= ~(A|B);
		
		Nand:
		result <= ~(A&B);
		
		Slt: 
		result <= A<B ?1'b1:1'b0;
		
		Sub:
		result <= A-B;
		
		default:
		result <=32'bx;
	endcase

	end



endmodule