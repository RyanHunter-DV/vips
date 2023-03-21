`ifndef resetGenSeq__svh
`define resetGenSeq__svh
class ResetGenSeq extends uvm_sequence;
	realtime _stime;
	int _index;
	logic _value;
	`uvm_object_utils_begin(ResetGenSeq)
		`uvm_field_real(_stime,UVM_ALL_ON)
		`uvm_field_int(_index,UVM_ALL_ON)
		`uvm_field_int(_value,UVM_ALL_ON)
	`uvm_object_utils_end
	extern  function  new(string name="ResetGenSeq");
	extern  task reset(int idx,logic val,realtime t,uvm_sequencer_base seqr);
	extern virtual task body();
endclass



function  ResetGenSeq::new(string name="ResetGenSeq");
	super.new(name);
endfunction
task ResetGenSeq::reset(int idx,logic val,realtime t,uvm_sequencer_base seqr);
	_stime=t;
	_index=idx;
	_value=val;
	this.start(seqr);
endtask
task ResetGenSeq::body();
	ResetGen tr=new("tr");
	tr.stime=_stime;
	tr.index=_index;
	tr.value=_value;
	start_item(tr);
	finish_item(tr);
endtask
`endif
