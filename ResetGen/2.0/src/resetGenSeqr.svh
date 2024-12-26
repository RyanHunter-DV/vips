`ifndef resetGenSeqr__svh
`define resetGenSeqr__svh
class ResetGenSeqr#(type REQ=ResetGenTrans,RSP=REQ) extends uvm_sequencer#(REQ,RSP);
	`uvm_component_utils_begin(ResetGenSeqr#(REQ,RSP))
	`uvm_component_utils_end
	extern  function  new(string name="ResetGenSeqr",uvm_component parent=null);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
	extern virtual task run_phase(uvm_phase phase);
endclass



function  ResetGenSeqr::new(string name="ResetGenSeqr",uvm_component parent=null);
	super.new(name,parent);
endfunction
function void ResetGenSeqr::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction
function void ResetGenSeqr::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
endfunction
task ResetGenSeqr::run_phase(uvm_phase phase);
	super.run_phase(phase);
endtask
`endif
