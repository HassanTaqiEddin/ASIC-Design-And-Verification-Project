
class sequencer extends uvm_sequencer #(sequence_item);
  
  
  `uvm_component_utils(sequencer)
  sequence_item obj_sequence_item;

  	function new(string name = "sequencer",uvm_component parent=null);
		super.new(name);
	endfunction
  
	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		$display("Sequencer Build Phase started");		
		obj_sequence_item = sequence_item::type_id::create("obj_sequence_item");
	endfunction

	function void connect_phase (uvm_phase phase);
		super.connect_phase(phase);
		$display("Sequencer Connect Phase started");
	endfunction

  	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		$display("Sequencer Run Phase started");
	endtask
	
endclass