`ifndef ActiveResetWithRandomDuration__svh
`define ActiveResetWithRandomDuration__svh

class ActiveResetWithRandomDuration extends ResetGenExampleBaseTest;
	
	`uvm_component_utils_begin(ActiveResetWithRandomDuration)
	`uvm_component_utils_end
// public
	function new(string name="ActiveResetWithRandomDuration",uvm_component parent=null);
		super.new(name,parent);
	endfunction
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
	extern virtual task run_phase(uvm_phase phase);
	// testRun, description
	extern virtual task testRun;
// private
endclass

task ActiveResetWithRandomDuration::testRun; // ##{{{
	begin
		ResetGenRandomActiveSeq s=new("s");
		s.add(refReset,1,600);s.add(dutReset,100,400);
		s.drainTime=100us;
		s.start(env.rg.sequencer);
	end
endtask // ##}}}

function void ActiveResetWithRandomDuration::build_phase(uvm_phase phase); //##{{{
	super.build_phase(phase);
endfunction //##}}}
function void ActiveResetWithRandomDuration::connect_phase(uvm_phase phase); //##{{{
	super.connect_phase(phase);
endfunction //##}}}
task ActiveResetWithRandomDuration::run_phase(uvm_phase phase); //##{{{
	super.run_phase(phase);
endtask //##}}}


`endif