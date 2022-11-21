`ifndef rhAhb5MstSeqr__svh
`define rhAhb5MstSeqr__svh

class RhAhb5MstSeqr #( type REQ=RhAhb5ReqTrans,RSP=RhAhb5RspTrans) extends uvm_sequencer#(REQ,RSP);
	`uvm_component_utils_begin(RhAhb5MstSeqr#(REQ,RSP))
	`uvm_component_utils_end
	extern function  new(string name="RhAhb5MstSeqr",uvm_component parent=null);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
	extern virtual task run_phase(uvm_phase phase);
endclass
function  RhAhb5MstSeqr::new(string name="RhAhb5MstSeqr",uvm_component parent=null);
	super.new(name,parent);
endfunction
function void RhAhb5MstSeqr::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction
function void RhAhb5MstSeqr::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
endfunction
task RhAhb5MstSeqr::run_phase(uvm_phase phase);
endtask

`endif
