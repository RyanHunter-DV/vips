`ifndef ResetGenRandomActiveSeq__svh
`define ResetGenRandomActiveSeq__svh

class ResetGenRandomActiveSeq extends ResetGenBaseSeq;
	parameter type TR=ResetGenTrans;
	realtime timeUnit=1ns;
	int mins[int];
	int maxes[int];

	`uvm_object_utils_begin(ResetGenRandomActiveSeq#(TR))
	`uvm_object_utils_end

	function new(string name="ResetGenRandomActiveSeq");
		super.new(name);
	endfunction

	extern virtual task body();
	// add(string name,int min,int max) -> void, 
	// use the int to randomize the time with a fixed time unit in class
	function void add(int index,int min,int max); // ##{{{
		if (mins.exists(index)) return;
		mins[index]=min;
		maxes[index]=max;
	endfunction // ##}}}
endclass

task ResetGenRandomActiveSeq::body(); //##{{{
	foreach (mins[n]) begin
		TR t=new($sformatf("trans-%0d",n));
		t.index=n;
		t.duration=$urandom_range(mins[n],maxes[n])*timeUnit;
		`uvm_info(get_type_name(),$sformatf("sending trans:\n%s",t.sprint()),UVM_HIGH)
		start_item(t);
		finish_item(t);
	end
	#(drainTime);
endtask // ##}}}

`endif