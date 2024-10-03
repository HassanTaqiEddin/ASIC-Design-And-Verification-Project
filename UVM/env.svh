
class env extends uvm_env;

  `uvm_component_utils(env)
  agent obj_agent;
  subscriber obj_subscriber;
  scoreboard obj_scoreboard;
  
  virtual intf vif;
  
  function new(string name = "env", uvm_component parent = null);
		super.new(name, parent);
	endfunction	

	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		$display("Env Build Phase started");
      	obj_agent = agent::type_id::create("obj_agent", this);
     	obj_subscriber = subscriber::type_id::create("obj_subscriber", this);
   	   	obj_scoreboard = scoreboard::type_id::create("obj_scoreboard", this);
      
      if(!uvm_config_db#(virtual intf)::get(this, "", "my_vif", vif))
         `uvm_fatal(get_full_name(), "Error!")
        uvm_config_db#(virtual intf)::set(this,"obj_agent","my_vif", vif);
        uvm_config_db#(virtual intf)::set(this,"obj_scoreboard","my_vif", vif);

      
	endfunction

	function void connect_phase (uvm_phase phase);
		super.connect_phase(phase);
		$display("Env Connect Phase started");
		obj_agent.analysis_port.connect(obj_subscriber.analysis_export);
		obj_agent.analysis_port.connect(obj_scoreboard.analysis_imp);

	endfunction


endclass