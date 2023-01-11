`ifndef rhGpvProtocolBase__svh
`define rhGpvProtocolBase__svh

virtual class RhGpvProtocolBase extends uvm_object;

	function new(string name="RhGpvProtocolBase");
		super.new(name);
	endfunction

	pure function RhGpvDataObj req2dobj(RhGpvTrans req);
endclass

`endif