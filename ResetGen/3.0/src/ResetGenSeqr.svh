`ifndef ResetGenSeqr__svh
`define ResetGenSeqr__svh

class ResetGenSeqr#(type REQ=ResetGenTrans,RSP=REQ) extends uvm_sequencer#(REQ,RSP);
	
	`uvm_component_utils_begin(ResetGenSeqr#(REQ,RSP))
	`uvm_component_utils_end
// public
	function new(string name="ResetGenSeqr",uvm_component parent=null);
		super.new(name,parent);
	endfunction
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
	extern virtual task run_phase(uvm_phase phase);
// private
endclass

function void ResetGenSeqr::build_phase(uvm_phase phase); //##{{{
	super.build_phase(phase);
endfunction //##}}}
function void ResetGenSeqr::connect_phase(uvm_phase phase); //##{{{
	super.connect_phase(phase);
endfunction //##}}}
task ResetGenSeqr::run_phase(uvm_phase phase); //##{{{
	super.run_phase(phase);
endtask //##}}}

`endif