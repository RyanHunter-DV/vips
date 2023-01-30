`ifndef rhAhb5ResponderBase__svh
`define rhAhb5ResponderBase__svh

class RhAhb5ResponderBase #(type REQ=RhAhb5ReqTrans,RSP=RhAhb5RspTrans) extends uvm_object;
	
	RhuDebugger debug;
	`uvm_object_utils(RhAhb5ResponderBase#(REQ,RSP));

	function new(string name = "RhAhb5ResponderBase");
		super.new(name);
		debug = new(this,"object");
	endfunction

	extern function RSP generateResponse (REQ req);
	extern virtual function void addUserResponseFields (ref RSP rsp,input REQ req);
endclass
function void RhAhb5ResponderBase::addUserResponseFields(ref RSP rsp,input REQ req); // ##{{{
	`uvm_warning("generateResponse","generate response in base responder is not suppose to happend")
	`debug("in addUserResponseFields, nothing added")
endfunction // ##}}}
function RSP RhAhb5ResponderBase::generateResponse(REQ req); // ##{{{
	RSP rsp = new("rsp");
	rsp.iswrite = req.write;
	addUserResponseFields(rsp,req);
	return rsp;
endfunction // ##}}}

`endif
