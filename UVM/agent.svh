
class agent extends uvm_agent;

  `uvm_component_utils(agent)

  sequencer	obj_sequencer;
  driver obj_driver;
  monitor obj_monitor;
  
  virtual intf vif;
  
  uvm_analysis_port #(sequence_item) analysis_port;

  	function new(string name = "agent", uvm_component parent = null);
		super.new(name, parent);
	endfunction	
	
	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
      	obj_sequencer = sequencer::type_id::create("obj_sequencer", this);
     	obj_driver = driver::type_id::create("obj_driver", this);
   	   	obj_monitor = monitor::type_id::create("obj_monitor", this);

		analysis_port=new("analysis_port",this);  
      // For DB send and get the virtual interface 
        if(!uvm_config_db#(virtual intf)::get(this, "", "my_vif", vif))
         `uvm_fatal(get_full_name(), "Error!")
        uvm_config_db#(virtual intf)::set(this,"obj_driver","my_vif", vif);
    	uvm_config_db#(virtual intf)::set(this,"obj_monitor","my_vif", vif);
		
      $display("Agent Build Phase started");
	endfunction

	function void connect_phase (uvm_phase phase);
		super.connect_phase(phase);
		$display("Agent Connect Phase started");
		obj_driver.seq_item_port.connect(obj_sequencer.seq_item_export);
		obj_monitor.analysis_port.connect(this.analysis_port);
	endfunction


endclass