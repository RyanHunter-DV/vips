`ifndef InitWithManualDurationTest__svh
`define InitWithManualDurationTest__svh

class InitWithManualDurationTest extends ResetGenExampleBaseTest;
	
	`uvm_component_utils_begin(InitWithManualDurationTest)
	`uvm_component_utils_end
// public
	function new(string name="InitWithManualDurationTest",uvm_component parent=null);
		super.new(name,parent);
	endfunction
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
	// testRun, description
// private
endclass

function void InitWithManualDurationTest::build_phase(uvm_phase phase); //##{{{
	super.build_phase(phase);
endfunction //##}}}
function void InitWithManualDurationTest::connect_phase(uvm_phase phase); //##{{{
	super.connect_phase(phase);
	rg.init("refReset",ResetActive,.manualInactiveDuration(400ns));
	rg.init("dutReset",ResetActive,.manualInactiveDuration(800ns));
endfunction //##}}}


`endif