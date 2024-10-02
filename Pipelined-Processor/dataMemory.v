


module dataMemory( address , writeData , readData , readEn , writeEn , clk);

 //Inputs
 input clk , readEn , writeEn;
 input [31:0] address , writeData;

 //Output
 output  [31:0] readData;

 //Creating the memory vector
 reg [31:0] dataMemory [0:255];

 //Initialize memory 
 initial begin
 $readmemh("dataMemory_init.txt", dataMemory); 
 end

 //Write operation
 always @(posedge clk )begin

    if(writeEn) begin
	
        dataMemory [address] <= writeData;
    end
 end

 //Read operation 
 assign readData = (readEn) ?dataMemory[address] :32'bx ;


 endmodule
