

class test extends uvm_test;

   // Registration 
  `uvm_component_utils(test)

	// Define the instances of bottom classes (env, Sequence)
	env obj_env;
	Sequence obj_Sequence;

	// To deliver database from top to bottom
	virtual intf vif;


	function new(string name = "test",uvm_component parent=null);
		super.new(name,parent);
	endfunction	
	
	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		$display("Test Build Phase started");
		obj_env = env::type_id::create("obj_env", this);
		obj_Sequence = Sequence::type_id::create("obj_Sequence");

		if (!uvm_config_db#(virtual intf)::get(this, "", "my_vif", vif))
			`uvm_fatal(get_full_name(), "could not get vif");

		uvm_config_db#(virtual intf)::set(this, "obj_env", "my_vif", vif);

	endfunction
	

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		$display("Test Connect Phase started");
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		$display("Test Run Phase started");
		phase.raise_objection(this);
		obj_Sequence.start(obj_env.obj_agent.obj_sequencer);
		phase.drop_objection(this);
	endtask



endclass

