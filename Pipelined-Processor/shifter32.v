

 // this module shifts any input by two bits, "multiply by 4"
 // used in cpu to calculate the branch target
 module shifter32 (in, out);

 //32bit input to shift
 input wire [31:0] in;
 //32bit output (shifted value )
 output wire [31:0] out;

 //concatination between lowest 30bit and two zero's
 assign out = {in[29:0], 2'b00};

 endmodule