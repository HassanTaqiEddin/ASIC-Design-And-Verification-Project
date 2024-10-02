
 
 // 32 -bit 2x1 mux
 module mux2x1 (X, Y, s, M);

	 // Inputs
	 input [31:0] X; // First input
	 input [31:0] Y; // Second input
	 input  s;	 //Selector line 

	 // Output
	 output reg [31:0] M; //Mux output

	 always @(*)
		 case (s)
			 1'b0: M = X;	// Choose First input if the selector equals "00"
			 1'b1: M = Y;	//Choose Second input if the selector equals "01"
			 default: M = 32'hxxxx; // Error state
		 endcase
 endmodule