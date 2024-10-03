
interface intf(input logic clk);
	logic reset;
    logic [4:0] readReg1, readReg2;
  	logic [4:0 ] writeReg;
    logic [31:0] writeData;
    logic writeEnable;
    logic [31:0] readData1,readData2;
  
endinterface