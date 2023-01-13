`ifndef rhGpvSignal__svh
`define rhGpvSignal__svh

class RhGpvSignal extends uvm_object;


	string group;
	int spos;
	int epos;

	`uvm_object_utils_begin(RhGpvSignal)
	`uvm_object_utils_end

	function new(string name="RhGpvSignal");
		super.new(name);
	endfunction

	extern function void position(int s,int e,string group);
endclass

function void RhGpvSignal::position(int s,int e,string g);
	group = g;
	spos  = s;
	epos  = e;
endfunction
`endif