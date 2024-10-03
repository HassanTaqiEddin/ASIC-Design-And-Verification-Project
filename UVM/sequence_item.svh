

class sequence_item extends uvm_sequence_item;
	 `uvm_object_utils(sequence_item)
	logic clk;

	rand logic reset;
    rand logic [4:0] readReg1;
	rand logic [4:0] readReg2;
	randc logic [4:0 ] writeReg;
    rand logic [31:0] writeData;
	rand logic writeEnable;
	
    logic [31:0] readData1,readData2;

	function new(string name = "sequence_item");
		super.new(name);
	endfunction

	constraint distinctRegs {
		readReg1 != writeReg;
		readReg2 != writeReg;
	}

	constraint validRegRange {
    readReg1 inside {[0:31]};
    readReg2 inside {[0:31]};
    writeReg inside {[0:31]};
	}

	constraint noWriteOnZaro {
      if (writeReg == 0) 
        writeEnable == 0;
    }

  constraint resetDeal {
    reset == (writeReg == 5'hc) ? 0 : 1;
  }


	constraint enablePercentage {
		writeEnable dist {0 := 30, 1 := 70};
	}

endclass