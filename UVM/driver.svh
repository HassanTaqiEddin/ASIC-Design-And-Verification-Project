

class driver extends uvm_driver #(sequence_item);
  `uvm_component_utils(driver)
   
   sequence_item obj_sequence_item;
   virtual intf vif;

  	function new(string name = "driver",uvm_component parent = null);
		super.new(name, parent);
	endfunction
	
	
	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		$display("Driver Build Phase started");

     	obj_sequence_item = sequence_item::type_id::create("obj_sequence_item");
      
        if(!uvm_config_db#(virtual intf)::get(this, "", "my_vif", vif))
         `uvm_fatal(get_full_name(), "Error!")      
	endfunction


	task run_phase(uvm_phase phase);
      super.run_phase(phase);
      $display("Driver Run Phase started");
      forever begin
        `uvm_info("Driver",$sformatf("Wait for item for sequencer"),UVM_LOW)
        seq_item_port.get_next_item(obj_sequence_item);

        drive_item(obj_sequence_item);

        #1step seq_item_port.item_done();

        $display("%0t::DRIVER::reset= %h, WriteEnable= %h , WriteReg = %h,WriteData=%h,ReadReg1=%h,ReadReg2=%h",$time(),obj_sequence_item.reset,obj_sequence_item.writeEnable,obj_sequence_item.writeReg, obj_sequence_item.writeData, obj_sequence_item.readReg1, obj_sequence_item.readReg2);

		end
	endtask

	task drive_item(sequence_item obj_sequence_item);
	@(posedge vif.clk)
		vif.reset <= obj_sequence_item.reset;
		vif.writeEnable <= obj_sequence_item.writeEnable;
		vif.writeReg <= obj_sequence_item.writeReg;
		vif.writeData <= obj_sequence_item.writeData;
		vif.readReg1 <= obj_sequence_item.readReg1;
		vif.readReg2 <= obj_sequence_item.readReg2;
	endtask




	function void connect_phase (uvm_phase phase);
		super.connect_phase(phase);
		$display("Driver Connect Phase started");
	endfunction
 
 
endclass