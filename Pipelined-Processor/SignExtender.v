

// this module to extend input with zero bit or sign bit  depend on the input signal  
module SignExtender (in, out);

//16bit input 
	input wire [15:0] in;

	//32bit output
	output [31:0] out;

	//extending opreation
	 assign	out = {{16{in[15]}}, in};
	 

endmodule
