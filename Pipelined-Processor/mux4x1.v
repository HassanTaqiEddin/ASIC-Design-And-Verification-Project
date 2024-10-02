
 
 // 32 -bit 4x1 mux
 module mux4x1 (X, Y, Z, W, s, M);

 // Inputs
 input [31:0] X; // First input
 input [31:0] Y; // Second input
 input [31:0] Z; // Third input
 input [31:0] W; // Forth input
 input [1:0] s;	 //Selector line (2 bits)

 // Output
 output reg [31:0] M; //Mux output

 always @(*)

 case (s)
 2'b00: M = X;	// Choose First input if the selector equals "00"
 2'b01: M = Y;	//Choose Second input if the selector equals "01"
 2'b10: M = Z;	//Choose Third input if the selector equals "10"
 2'b11: M = W;	//Choose Forth input if the selector equals "11"
 default: M = 32'hxxxx; // Error state

 endcase
 endmodule