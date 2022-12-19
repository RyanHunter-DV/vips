`ifndef rhAhb5TransBase__svh
`define rhAhb5TransBase__svh

class RhAhb5TransBase extends uvm_transaction;
	realtime stime,etime; // record time for the trans start/end
	bit started = 0;
	`uvm_object_utils_begin(RhAhb5TransBase)
	`uvm_object_utils_end
	extern function void record(realtime t);
	extern function  new(string name="RhAhb5TransBase");
endclass
function void RhAhb5TransBase::record(realtime t);
	if (started) etime = t;
	else begin
		stime = t;
		started = 1;
	end
endfunction
function  RhAhb5TransBase::new(string name="RhAhb5TransBase");
	super.new(name);
endfunction

`endif
