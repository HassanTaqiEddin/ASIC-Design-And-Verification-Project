
class scoreboard extends uvm_scoreboard;

  `uvm_component_utils(scoreboard)

  virtual intf vif;

  sequence_item obj_sequence_item;

  logic [31:0] readData1_expec, readData2_expec;
  
  logic [31:0] regfile_expec [31:0]; 

  int error_count, correct_count;

  uvm_analysis_imp #(sequence_item, scoreboard) analysis_imp;

  function new(string name = "scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    $display("Scoreboard Build Phase started");
    obj_sequence_item = sequence_item::type_id::create("obj_sequence_item");
    analysis_imp = new("analysis_imp", this);
        error_count = 0;
    correct_count = 0;

    for (int i = 0; i < 32; i++) begin
      regfile_expec[i] = 32'b0;
    end
  endfunction

  virtual function void write(sequence_item obj_sequence_item);
    if (obj_sequence_item.writeEnable && (obj_sequence_item.writeReg != 5'b0)) begin
 	 regfile_expec[obj_sequence_item.writeReg] = obj_sequence_item.writeData;
	end

    if (!obj_sequence_item.reset) begin
      for (int i = 0; i < 32; i++) begin
        regfile_expec[i] = 32'b0; 
      end
      readData1_expec = 32'b0;
      readData2_expec = 32'b0;
    end
    else begin
      if (obj_sequence_item.writeEnable && (obj_sequence_item.writeReg != 5'b0)) begin
        regfile_expec[obj_sequence_item.writeReg] = obj_sequence_item.writeData;
      end

      readData1_expec = regfile_expec[obj_sequence_item.readReg1];
      readData2_expec = regfile_expec[obj_sequence_item.readReg2];
    end
    
    if ({readData1_expec, readData2_expec} !== {obj_sequence_item.readData1, obj_sequence_item.readData2}) begin
      $display("-------------------------------------------------------");
      $display("%0t::ERROR!", $time());
      $display("readData1_expected = %h, readData1 = %h", readData1_expec, obj_sequence_item.readData1);
      $display("readData2_expected = %h, readData2 = %h", readData2_expec, obj_sequence_item.readData2);
      $display("-------------------------------------------------------");
      error_count = error_count + 1;
    end
    else begin
      $display("-------------------------------------------------------");
      $display("%0t::PASS!", $time());
      $display("readData1_expected = %h, readData1 = %h", readData1_expec, obj_sequence_item.readData1);
      $display("readData2_expected = %h, readData2 = %h", readData2_expec, obj_sequence_item.readData2);
      $display("-------------------------------------------------------");
      correct_count = correct_count + 1;
    end

    $display("correct_count = %d, error_count = %d", correct_count, error_count);
  endfunction
endclass
