`ifndef ResetGenIf__sv
`define ResetGenIf__sv

interface ResetGenIf #(RM=10) (input logic [RM-1:0] clk);
	logic [RM-1:0] reset;

	// the global index indicates current reset been mapped.
	// each time the addReset is called, the index will add 1.
	//local int index;

	// 2.sync the clock by given index: repeat(cycle) @(posedge clk[index])
	// 3.return
	task sync(int id,int cycle=1);
		if (id>-1) repeat (cycle) @(posedge clk[id]);
	endtask


	// 2.drive the reset[index] = v
	task drive(int id,logic v);
		if (id>-1) reset[id] = v;
	endtask


	// config.vif.waitResetNotEqualTo(name,o.getSignalValue(current));
	task automatic waitResetNotEqualTo(int id,logic v);
		wait (reset[id]!==v);
	endtask //automatic

	function logic getResetValue(int id);
		return reset[id];
	endfunction //automatic

endinterface

`endif