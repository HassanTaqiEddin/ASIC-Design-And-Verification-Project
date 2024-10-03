
class monitor extends uvm_monitor;
  
  `uvm_component_utils(monitor)

   sequence_item obj_sequence_item;
   virtual intf vif;

   uvm_analysis_port #(sequence_item) analysis_port;

	function new(string name = "monitor", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		$display("Monitor Build Phase started");
   		obj_sequence_item = sequence_item::type_id::create("obj_sequence_item");

      if(!uvm_config_db#(virtual intf)::get(this, "", "my_vif", vif))
         `uvm_fatal(get_full_name(), "Error!")
      analysis_port =new("analysis_port",this);
	endfunction

	function void connect_phase (uvm_phase phase);
		super.connect_phase(phase);
		$display("Monitor Connect Phase started");
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		$display("Monitor Run Phase started");
		forever begin
		@(posedge vif.clk)
			obj_sequence_item.reset <= vif.reset;
			obj_sequence_item.writeEnable <= vif.writeEnable;
			obj_sequence_item.writeReg <= vif.writeReg;
			obj_sequence_item.writeData <= vif.writeData;
			obj_sequence_item.readReg1 <= vif.readReg1;
			obj_sequence_item.readReg2 <= vif.readReg2;
			obj_sequence_item.readData1 <= vif.readData1;
			obj_sequence_item.readData2 <= vif.readData2;
			#1step analysis_port.write(obj_sequence_item);

          $display("%0t::Monitor::reset= %h, WriteEnable= %h , WriteReg = %h ,WriteData=%h, ReadReg1= %h, ReadReg2=%h, ReadData1= %h, ReadData2=%h",$time(), obj_sequence_item.reset,obj_sequence_item.writeEnable, obj_sequence_item.writeReg, obj_sequence_item.writeData, obj_sequence_item.readReg1, obj_sequence_item.readReg2, obj_sequence_item.readData1, obj_sequence_item.readData2);


		end


	endtask

  
  
endclass