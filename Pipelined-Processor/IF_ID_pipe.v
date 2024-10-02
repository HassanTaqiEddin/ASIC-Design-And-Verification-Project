
  //this module for the first pipe (fetch and decode pipe)
module IF_ID_pipe(inpcAdderResult, inInstruction ,outInstruction, outpcAdderResult, clock,reset);

  //define inputs (wires)
  input wire [31:0] inpcAdderResult ;
  input wire [31:0] inInstruction ;

  // clock and reset
  input wire clock ;
  input wire reset;

  //define outputs (registers)
  output reg [31:0] outInstruction;
  output reg [31:0] outpcAdderResult;
   
   always @(posedge clock ) begin
     //if resrt =0 all outputs are 0
       if (!reset)   // active low reset  
           begin
               outInstruction <= 32'b0; 
               outpcAdderResult<= 32'b0;
           end 
		   else  begin
				outInstruction<= inInstruction;
                outpcAdderResult <= inpcAdderResult;
            end
        end

endmodule