`ifndef Axi4ResponseHandlerBase__svh
`define Axi4ResponseHandlerBase__svh

class Axi4ResponseHandlerBase extends uvm_object; // {

	Axi4SeqrBase seqr;
	uvm_analysis_imp #(Axi4SeqItem,Axi4ResponseHandlerBase) reqI;

	`uvm_object_utils(Axi4ResponseHandlerBase)

	function new(string name="Axi4ResponseHandlerBase");
		super.new(name);
		reqI = new("reqI");
	endfunction


	extern function void setSeqr(Axi4SeqrBase seqr);
	extern function void write(Axi4SeqItem t);
	virtual task processReq(Axi4SeqItem t); endtask
endclass // }

function void Axi4ResponseHandlerBase::write(Axi4SeqItem t); // {
	fork
		processReq(t);
	join_none
endfunction // }

function void Axi4ResponseHandlerBase::setSeqr(Axi4SeqrBase _seqr); // {
	seqr = _seqr;
endfunction // }

`endif
