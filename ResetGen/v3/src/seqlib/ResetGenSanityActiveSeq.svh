`ifndef ResetGenSanityActiveSeq__svh
`define ResetGenSanityActiveSeq__svh

//  Class: ResetGenSanityActiveSeq
//
class ResetGenSanityActiveSeq extends ResetGenBaseSeq;

	realtime names[string];

	`uvm_object_utils(ResetGenSanityActiveSeq#(TR));
	`uvm_declare_p_sequencer(ResetGenSeqr)

	//  Constructor: new
	function new(string name = "ResetGenSanityActiveSeq");
		super.new(name);
	endfunction: new

	//  Task: pre_start
	//  This task is a user-definable callback that is called before the optional 
	//  execution of <pre_body>.
	// extern virtual task pre_start();

	//  Task: pre_body
	//  This task is a user-definable callback that is called before the execution 
	//  of <body> ~only~ when the sequence is started with <start>.
	//  If <start> is called with ~call_pre_post~ set to 0, ~pre_body~ is not called.
	// extern virtual task pre_body();

	//  Task: pre_do
	//  This task is a user-definable callback task that is called ~on the parent 
	//  sequence~, if any. The sequence has issued a wait_for_grant() call and after
	//  the sequencer has selected this sequence, and before the item is randomized.
	//
	//  Although pre_do is a task, consuming simulation cycles may result in unexpected
	//  behavior on the driver.
	// extern virtual task pre_do(bit is_item);

	//  Function: mid_do
	//  This function is a user-definable callback function that is called after the 
	//  sequence item has been randomized, and just before the item is sent to the 
	//  driver.
	// extern virtual function void mid_do(uvm_sequence_item this_item);

	//  Task: body
	//  This is the user-defined task where the main sequence code resides.
	virtual task body(); // ##{{{
		foreach (names[n]) begin
			TR t=new(n);
			t.name=n;
			t.duration=names[n];
			`uvm_info(get_type_name(),$sformatf("sending trans:\n%s"t.sprint()),UVM_HIGH)
			start_item(t);
			finish_item(t);
		end
		#(drainTime);
	endtask // ##}}}

	//  Function: post_do
	//  This function is a user-definable callback function that is called after the 
	//  driver has indicated that it has completed the item, using either this 
	//  item_done or put methods. 
	// extern virtual function void post_do(uvm_sequence_item this_item);

	//  Task: post_body
	//  This task is a user-definable callback task that is called after the execution 
	//  of <body> ~only~ when the sequence is started with <start>.
	//  If <start> is called with ~call_pre_post~ set to 0, ~post_body~ is not called.
	// extern virtual task post_body();

	//  Task: post_start
	//  This task is a user-definable callback that is called after the optional 
	//  execution of <post_body>.
	// extern virtual task post_start();
	
	// add(string n) -> void, 
	// add a new reset name to be drive by active sequence
	extern  function void add(string n);
endclass: ResetGenSanityActiveSeq

function void ResetGenSanityActiveSeq::add(string n,realtime d); // ##{{{
	if (names.exists(n)) return;
	names[n]=d;
endfunction // ##}}}

`endif