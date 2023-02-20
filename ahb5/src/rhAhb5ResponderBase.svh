`ifndef rhAhb5ResponderBase__svh
`define rhAhb5ResponderBase__svh

class RhAhb5ResponderBase extends uvm_object;
	parameter type REQ = RhAhb5ReqTrans;
	parameter type RSP = RhAhb5RspTrans;

	`uvm_object_utils_begin(RhAhb5ResponderBase)
	`uvm_object_utils_end

	function new(string name="RhAhb5ResponderBase");
		super.new(name);
	endfunction

	extern virtual function RSP generateResponse (REQ req);

endclass
function RSP RhAhb5ResponderBase::generateResponse(REQ req); // ##{{{
endfunction // ##}}}

`endif
