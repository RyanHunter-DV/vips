`ifndef resetGen_seqlib__svh
`define resetGen_seqlib__svh
typedef class resetGen_seqr;
class resetGen_defaultSeq extends uvm_sequence;

	string resetName;
	int activeCycle;
	int delayCycle;

	`uvm_object_utils_begin(resetGen_defaultSeq)
	`uvm_object_utils_end

	function new (string name="resetGen_defaultSeq");
		super.new(name);
	endfunction

	function void startDefaultReset(string n,int ac,int dc,resetGen_seqr seqr);
		resetName = n;
		activeCycle = ac;
		delayCycle = dc;
		fork
			this.start(seqr);
		join_none
	endfunction

	virtual task body();
		resetGen_trans tr=new("defaultTr");
		tr.randomize();
		tr.name=resetName;
		tr.activeCycles=activeCycle;
		tr.delayCycles=delayCycle;
		start_item(tr);
		finish_item(tr);
	endtask

endclass


`endif
