`ifndef ResetGenExampleBaseTest__svh
`define ResetGenExampleBaseTest__svh

class ResetGenExampleBaseTest extends uvm_test;
	ResetGenExampleEnv env;
	`uvm_component_utils_begin(ResetGenExampleBaseTest)
	`uvm_component_utils_end
// public
	function new(string name="ResetGenExampleBaseTest",uvm_component parent=null);
		super.new(name,parent);
	endfunction
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
	extern virtual task run_phase(uvm_phase phase);
	// testRun, virtual api for tests
	extern virtual task testRun;
// private
endclass
task ResetGenExampleBaseTest::testRun; // ##{{{
	begin
		ResetGenSanityActiveSeq s=new("s");
		s.add("refReset",399ns);s.add("dutReset",600ns);
		s.drainTime=99us;
		s.start(env.rg.sequencer);

		// another wayt to trigger active reset sequence.
		// using reset api to trigger a typical reset action.
		// more random resets shall be used by sequence-sequencer
		// two way to get reset handler, by api or direct reference, ResetGen rg=env.getResetGen();
		// env.rg.reset(.name("refReset"),.duration(399ns),.drainTime(100us);
		// env.rg.reset("dutReset",599ns,100us);
	end

endtask // ##}}}

function void ResetGenExampleBaseTest::build_phase(uvm_phase phase); //##{{{
	super.build_phase(phase);
	env = ResetGenExampleEnv::type_id::create("env",this);
endfunction //##}}}
function void ResetGenExampleBaseTest::connect_phase(uvm_phase phase); //##{{{
	super.connect_phase(phase);
endfunction //##}}}
task ResetGenExampleBaseTest::run_phase(uvm_phase phase); //##{{{
	phase.raise_objection(this);
	#1us;
	testRun;
	phase.drop_objection(this);
endtask //##}}}

`endif