

module clockDevider( CLOCK_50, reset, clk1HZ );
	
	parameter DELAY_1_SEC = 32'd50000000;   // 1 second
	parameter DELAY_2_SEC = 32'd100000000;  // 2 seconds
	parameter DELAY_5_SEC = 32'd250000000;  // 5 seconds
	parameter DELAY_10_SEC = 32'd500000000; // 10 seconds

	// Inputs
	input CLOCK_50, reset;
	// Output
	output reg clk1HZ;
	// Counter
	reg [24:0] count ;
	
	always @(posedge CLOCK_50 or negedge reset) begin
	
		if (~reset )begin
			count <= 25'b0;
			clk1HZ <= 1'b0;
		end
		
		else if (count < 12500000) count <= count + 25'd1;
		
		else begin
				clk1HZ <= ~clk1HZ;
				count <= 25'b0;
		end
	end
endmodule