
class subscriber extends uvm_subscriber #(sequence_item);

  
  `uvm_component_utils(subscriber)
   sequence_item obj_sequence_item;
  
	  covergroup cg;
    cp_readReg1 : coverpoint obj_sequence_item.readReg1 {
      bins reg1_bins[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31};
    }
    
    cp_readReg2 : coverpoint obj_sequence_item.readReg2 {
      bins reg2_bins[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31};
    }

    cp_writeReg : coverpoint obj_sequence_item.writeReg {
      bins write_reg_bins[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31};
    }

    // Coverpoint for write data
    cp_writeData : coverpoint obj_sequence_item.writeData {
      bins write_data_bins[] = {[0:15], [16:31], [32:63], [64:127], [128:255], [256:511], [512:1023], [1024:2047], [2048:4095]};
    }

    cp_writeEnable : coverpoint obj_sequence_item.writeEnable {
      bins enable_bins[] = {0, 1};
    }
    
  endgroup


	function void write(sequence_item t);
		obj_sequence_item = t;
		cg.sample();
	endfunction
	
	
	function new(string name = "subscriber", uvm_component parent = null);
		super.new(name, parent);
		cg=new();
	endfunction	
	
	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
      	obj_sequence_item = sequence_item::type_id::create("obj_sequence_item");
		$display("Subscriber Build Phase started");
	endfunction

	function void connect_phase (uvm_phase phase);
		super.connect_phase(phase);
		$display("Subscriber Connect Phase started");
	endfunction
 
 

endclass