`ifndef rh_ahbMstDrv__svh
`define rh_ahbMstDrv__svh

class rh_ahbMstDrv #(type REQ=rh_ahbMstTrans,RSP=REQ)
	extends rh_ahbDrvBase#(REQ,RSP); // {



	`uvm_component_utils_begin(rh_ahbMstDrv)
	`uvm_component_utils_end

	function new (string name="rh_ahbMstDrv", uvm_component parent=null);
		super.new(name,parent);
	endfunction

	extern function void build_phase(uvm_phase phase);

	extern virtual task activeDriverProcess;


endclass // }

function void rh_ahbMstDrv::build_phase(uvm_phase phase); // {
	super.build_phase(phase);

endfunction // }


task rh_ahbMstDrv::activeDriverProcess; // {
endtask // }


`endif
