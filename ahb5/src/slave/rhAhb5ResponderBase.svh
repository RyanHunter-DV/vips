`ifndef rhAhb5ResponderBase__svh
`define rhAhb5ResponderBase__svh

class RhAhb5ResponderBase #(type REQ=RhAhb5ReqTrans,RSP=RhAhb5RspTrans) extends uvm_object;
	
	RhAhb5SlvConfig config;
	`uvm_object_utils(RhAhb5ResponderBase#(REQ,RSP));

	function new(string name = "RhAhb5ResponderBase");
		super.new(name);
	endfunction

	extern function RSP processAddressPhase (REQ req);
	extern virtual function void addUserResponseFields (ref RSP rsp,input REQ req);

	// API to process the request after giving a response
	// for example, for a write request, slave must first answer the control channel: HREADY, HRESP response
	// then can answer the data channel HWDATA/HRDATA, to receive a write data or give out a read data
	extern virtual function void processDataPhase (REQ req,ref RSP rsp);
endclass
function void RhAhb5ResponderBase::processDataPhase(REQ req,ref RSP rsp); // ##{{{
	if (!req.write) rsp.rdata=$urandom; // this is example from base responder
endfunction // ##}}}
function void RhAhb5ResponderBase::addUserResponseFields(ref RSP rsp,input REQ req); // ##{{{
	`uvm_warning("processAddressPhase","generate response in base responder is not suppose to happend")
	`rhudbg("in addUserResponseFields, nothing added")
endfunction // ##}}}
function RSP RhAhb5ResponderBase::processAddressPhase(REQ req); // ##{{{
	RSP rsp = new("rsp");
	rsp.iswrite = req.write;
	addUserResponseFields(rsp,req);
	return rsp;
endfunction // ##}}}

`endif
