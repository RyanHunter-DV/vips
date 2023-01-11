`ifndef rwaccessProtocol__svh
`define rwaccessProtocol__svh

class RwaccessProtocol extends rhGpvProtocolBase;

	`uvm_object_utils_begin(RwaccessProtocol)
	`uvm_object_utils_begin


	function new(string name="RwaccessProtocol");
		super.new(name);
	endfunction

	extern virtual function RhGpvDataObj req2dobj(RhGpvTrans req);


endclass
function RhGpvDataObj RwaccessProtocol::req2dobj(RhGpvTrans req);
	RhGpvDataObj dobj=new("dobj");
	foreach (req.mask[i]) begin
		dobj.setDrivePosAndValue(req.mask[i],req.vector[i]);
		dobj.clockIndex = req.clockIndex;
	end
endfunction

`endif