`ifndef RhQLpiSeqr__svh
`define RhQLpiSeqr__svh

class RhQLpiSeqr#(type REQ=RhQLpiReqTrans,RSP=REQ) extends uvm_sequencer#(REQ,RSP);

	`uvm_component_utils_begin(RhQLpiSeqr#(REQ,RSP))
	`uvm_component_utils_end

	function new(string name="RhQLpiSeqr",uvm_component parent=null);
		super.new(name,parent);
	endfunction
endclass


`endif