`ifndef rhGpvConfig__svh
`define rhGpvConfig__svh

class RhGpvConfig extends uvm_object;

	RhGpvIfCtrl ifCtrl;

	`uvm_object_utils_begin(RhGpvConfig)
	`uvm_object_utils_end

	function new(string name="RhGpvConfig");
		super.new(name);
	endfunction

	extern task driveTransaction(RhGpvDataObj dobj);

endclass

task RhGpvConfig::driveTransaction(RhGpvDataObj dobj);

endtask
`endif