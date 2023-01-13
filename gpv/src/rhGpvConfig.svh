`ifndef rhGpvConfig__svh
`define rhGpvConfig__svh

class RhGpvConfig extends uvm_object;

	RhGpvIfCtrl ifCtrl;

	`uvm_object_utils_begin(RhGpvConfig)
	`uvm_object_utils_end

	function new(string name="RhGpvConfig");
		super.new(name);
	endfunction


	extern function void getInterface(string ifpath);
	extern function void driveVector(int s,int e,logicVector_t vector);
	// the return value starts from position 0 to the max size
	extern function logicVector_t getSignal(int s,int e);
	extern task sync(int pos, int cycle=1);
endclass

task RhGpvConfig::sync(int pos, int cycle);
	ifCtrl.vif.sync(pos,cycle);
endtask

function void RhGpvConfig::driveVector(int s,int e,logicVector_t vector);
	logic bits[];
	int size = e-s+1;
	bits = new[size];
	for (int pos=s;pos<=e;pos++) begin
		bits[pos-s] = vector[pos];
	end
	ifCtrl.vif.driveVector(s,bits);
endfunction

function void RhGpvConfig::getInterface(string ifpath);
	if (!uvm_config_db#(RhGpvIfCtrl)::get(null,"*",ifpath,ifCtrl))
		`uvm_fatal("NCFG",$sformatf("interface path(%s) not found",ifpath))
endfunction

`endif