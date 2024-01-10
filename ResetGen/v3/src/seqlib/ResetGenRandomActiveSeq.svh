`ifndef ResetGenRandomActiveSeq__svh
`define ResetGenRandomActiveSeq__svh

class ResetGenRandomActiveSeq extends ResetGenBaseSeq;
	parameter type TR=ResetGenTrans;
	realtime timeUnit=1ns;
	int mins[string];
	int maxes[string];

	`uvm_object_utils_begin(ResetGenRandomActiveSeq#(TR))
	`uvm_object_utils_end

	function new(string name="ResetGenRandomActiveSeq");
		super.new(name);
	endfunction

	extern virtual task body();
	// add(string name,int min,int max) -> void, 
	// use the int to randomize the time with a fixed time unit in class
	extern  function void add(string name,int min,int max);
endclass
function void ResetGenRandomActiveSeq::add(string name,int min,int max); // ##{{{
	if (mins.exists(name)) return;
	mins[name]=min;
	maxes[name]=max;
endfunction // ##}}}

task ResetGenRandomActiveSeq::body(); //##{{{
	foreach (mins[n]) begin
		TR t=new(n);
		t.name=n;
		t.duration=$urandom_range(mins[name],maxes[name])*timeUnit;
		`uvm_info(get_type_name(),$sformatf("sending trans:\n%s"t.sprint()),UVM_HIGH)
		start_item(t);
		finish_item(t);
	end
	#(drainTime);
endtask // ##}}}

`endif