
class Sequence extends uvm_sequence ;

  `uvm_object_utils(Sequence)
  sequence_item obj_sequence_item;
  parameter  numTests =100;

  function new(string name = "Sequence");
		super.new(name);
	endfunction

virtual task body;
  $display("Body task of Sequence");
  repeat(numTests) begin
    obj_sequence_item = sequence_item::type_id::create("obj_sequence_item");
    start_item(obj_sequence_item);
    assert (obj_sequence_item.randomize()) 
    else   $display("At %0t obj_sequence_item randomization failed",$time());
    finish_item(obj_sequence_item);
    
  end


endtask



endclass