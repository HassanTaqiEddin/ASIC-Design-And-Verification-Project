


module comparator (equal, a, b); 
	input [31:0]a, b; 
	output reg equal;
	always @(*) begin
	if (a==b)
		equal <= 1'b1;
	else
		equal <= 1'b0;
	end

endmodule 