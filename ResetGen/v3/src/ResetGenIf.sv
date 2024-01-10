`ifndef ResetGenIf__sv
`define ResetGenIf__sv

interface ResetGenIf #(RM=10) ();

	logic [RM-1:0] clk;
	logic [RM-1:0] reset;

	int resetMap[string];

	// the global index indicates current reset been mapped.
	// each time the addReset is called, the index will add 1.
	local int index;

	function void addReset(string name);
		resetMap[name] = index;
		index++;
	endfunction

	// 1.search the mapping info and return the bit index by given reset name.
	function int getIndexByName(string name);
		if (!resetMap.exists(name)) begin
			$error($time,", index not exists for reset(%s) !",name);
			return -1;
		end
		return resetMap[name];
	endfunction

	// 1.get name->index mapping
	// 2.sync the clock by given index: repeat(cycle) @(posedge clk[index])
	// 3.return
	task sync(string name,int cycle=1);
		int id = getIndexByName(name);
		if (id>-1) repeat (cycle) @(posedge clk[id]);
	endtask


	// 1.get name->index mapping
	// 2.drive the reset[index] = v
	task drive(string name,logic v);
		int id=getIndexByName(name);
		if (id>-1) reset[id] = v;
	endtask

endinterface

`endif