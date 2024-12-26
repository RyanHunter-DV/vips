`ifndef ActiveHighResetTest__svh
`define ActiveHighResetTest__svh

class ActiveHighResetTest extends ResetGenExampleBaseTest;
	
	`uvm_component_utils_begin(ActiveHighResetTest)
	`uvm_component_utils_end
// public
	function new(string name="ActiveHighResetTest",uvm_component parent=null);
		super.new(name,parent);
	endfunction
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
	task automatic run_phase(uvm_phase phase);
		phase.raise_objection(this);
		`uvm_info("TEST","running idle for 100us",UVM_LOW)
		#100us;
		phase.drop_objection(this);
	endtask //automatic
// private
endclass

function void ActiveHighResetTest::build_phase(uvm_phase phase); //##{{{
	super.build_phase(phase);
endfunction //##}}}
function void ActiveHighResetTest::connect_phase(uvm_phase phase); //##{{{
	super.connect_phase(phase);
	env.rg.activeValue(refReset,1);
	env.rg.activeValue(dutReset,1);
endfunction //##}}}


`endif