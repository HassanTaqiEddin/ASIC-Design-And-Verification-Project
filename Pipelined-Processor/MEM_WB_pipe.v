


   module MEM_WB_pipe(inRegWriteEn,inMemtoReg, inpcNext,indataMemOut,inaluResult,inWBAddress,
					outRegWriteEn,outMemtoReg, outpcNext,outdataMemOut,outaluResult,outWBAddress,
						 clock , reset);
							 
	// clock and reset
   input clock , reset ;						 
   
   //input
	input wire inRegWriteEn;
	input wire [1:0] inMemtoReg;
	
	input wire [31:0] inpcNext;
	input wire [31:0] indataMemOut;
	input wire [31:0] inaluResult;
	input wire [4 :0] inWBAddress;
  

   
   //output
	output reg outRegWriteEn;
	output reg [1:0] outMemtoReg;
	output reg [31:0] outpcNext;
	output reg [31:0] outdataMemOut;
	output reg [31:0] outaluResult;
	output reg [4 :0] outWBAddress;
   


   always @(posedge clock or negedge reset ) begin
       if (!reset)
           begin
			outRegWriteEn<=0;
			outMemtoReg  <=0;
			outpcNext	 <=0;
			outdataMemOut<=0;
			outaluResult <=0;
			outWBAddress <=0;
        end 
	    else  begin
			outRegWriteEn<=inRegWriteEn;
			outMemtoReg  <=inMemtoReg;
			outpcNext	 <=inpcNext;
			outdataMemOut<=indataMemOut;
			outaluResult <=inaluResult;
			outWBAddress <=inWBAddress;
		    
        end       
            
    end
		

endmodule