`ifndef resetGen_if__sv
`define resetGen_if__sv

// PS: one reset uvc only supports all reset outputs that within the same
// clock domain, async reset outputs shoulbe achieved by multiple resetGen UVCs
interface resetGen_if#(MAXRSTS=2048) (input logic iClk); // {

	logic [MAXRSTS-1:0] oReset;
	int resetIndex[string];

	// repeat <c> cycles of iClk
	task automatic clockSync(int c);
		repeat (c) @(posedge iClk);
	endtask
	// if not exists, then give out a new index and record it to resetIndex
	function automatic int getResetIndex(string n);
		static int gIdx=0;
		if (!resetIndex.exists(n)) begin
			resetIndex[n]=gIdx;
			gIdx++;
		end
		return resetIndex[n];
	endfunction

	task automatic _resetForkThread(int idx,bit active,int ac);
		oReset[idx] = active;
		clockSync(ac);
		oReset[idx] <= ~active;
	endtask

	// task, driveReset
	// to drive a reset according to specified name
	// active: indicates the active level
	// ac: active cycles, and then drive it done.
	task automatic driveReset(string n,bit active,int ac);
		int index = getResetIndex(n);
		fork
			_resetForkThread(index,active,ac);
		join_none
	endtask

endinterface // }


`endif
