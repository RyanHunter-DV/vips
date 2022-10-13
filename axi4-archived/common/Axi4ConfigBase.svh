`ifndef Axi4ConfigBase__svh
`define Axi4ConfigBase__svh

class Axi4ConfigBase extends uvm_object; // {

	local int lowDurationMin[string], lowDurationMax[string];
	local int highDurationMin[string],highDurationMax[string];

	`uvm_object_utils_begin(Axi4ConfigBase)
	`uvm_object_utils_end

	function new(string name="Axi4ConfigBase");
		super.new(name);
		// for master
		lowDurationMin["BREADY"]  = 0;
		lowDurationMax["BREADY"]  = 100;
		highDurationMin["BREADY"] = 0;
		highDurationMax["BREADY"] = 100;
		lowDurationMin["RREADY"]  = 0;
		lowDurationMax["RREADY"]  = 100;
		highDurationMin["RREADY"] = 0;
		highDurationMax["RREADY"] = 100;

		// for slave
		lowDurationMin["ARREADY"] = 0;
		lowDurationMax["ARREADY"] = 100;
		highDurationMin["ARREADY"]= 0;
		highDurationMax["ARREADY"]= 100;
		lowDurationMin["AWREADY"] = 0;
		lowDurationMax["AWREADY"] = 100;
		highDurationMin["AWREADY"]= 0;
		highDurationMax["AWREADY"]= 100;
		lowDurationMin["WREADY"]  = 0;
		lowDurationMax["WREADY"]  = 100;
		highDurationMin["WREADY"] = 0;
		highDurationMax["WREADY"] = 100;
	endfunction


	// virtual task, implemented in Axi4Config, call vif to drive signals according
	// to different id
	virtual task drive(string id,ref Axi4ChannelInfo info); endtask
	extern function int lowDuration (string id, int min=-1, max=-1);
	extern function int highDuration(string id, int min=-1, max=-1);
	pure virtual task sync(int cycle=1);
endclass // }

function int Axi4ConfigBase::highDuration(string id, int min=-1, max=-1); // {
	int _t;
	if (min>=0) highDurationMin[id] = min;
	if (max>=0) highDurationMax[id] = max;
	return std::randomize(_t) with {_t inside {[highDurationMin[id]:highDurationMax[id]]}};
endfunction // }

function int Axi4ConfigBase::lowDuration(string id, int min=-1, max=-1); // {
	int _t;
	if (min>=0) lowDurationMin[id] = min;
	if (max>=0) lowDurationMax[id] = max;
	return std::randomize(_t) with {_t inside {[lowDurationMin[id]:lowDurationMax[id]]}};
endfunction // }



`endif
