`include "interface.sv"
`include "package.sv"

module top;

  import uvm_pkg::*;
  import tb_pkg::*;

  logic clk;
  
  intf vif(clk);

  RegisterFile RF (
    .readReg1(vif.readReg1),
    .readReg2(vif.readReg2),
    .writeReg(vif.writeReg),
    .writeEnable(vif.writeEnable),
    .writeData(vif.writeData),
    .readData1(vif.readData1),
    .readData2(vif.readData2),
    .clk(clk),
    .reset(vif.reset) 
  );

  initial begin
    uvm_config_db#(virtual intf)::set(null, "uvm_test_top", "my_vif", vif);  
    run_test("test"); 
  end

  initial begin
    clk = 0;
  end
  
  always #10 clk = ~clk; 
  

endmodule
