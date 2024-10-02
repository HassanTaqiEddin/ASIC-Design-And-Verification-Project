
 // adder which add  two 32-bit binary numbers
 module adder32Bit (

	 // 32-bit input 
	 input [31:0] in1,    
	 input [31:0] in2,

	 // 32-bit output 
	 output wire [31:0] out  
	 );
	 
	 // Calculate the sum of input in and input in and assign it to the output
	 assign out = in1 + in2; 
	 
 endmodule
