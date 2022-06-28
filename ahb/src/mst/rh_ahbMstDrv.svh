`ifndef rh_ahbMstDrv__svh
`define rh_ahbMstDrv__svh

class rh_ahbMstDrv #(type REQ=rh_ahbMstTrans,RSP=REQ)
	extends rh_ahbDrvBase#(REQ,RSP); // {


	uvm_analysis_imp_rsp #(RSP,rh_ahbMstDrv) rspI;


	`uvm_component_utils_begin(rh_ahbMstDrv)
	`uvm_component_utils_end

	function new (string name="rh_ahbMstDrv", uvm_component parent=null);
		super.new(name,parent);
	endfunction

	extern function void build_phase(uvm_phase phase);

	extern virtual task mainProcessTask;


endclass // }

function void rh_ahbMstDrv::build_phase(uvm_phase phase); // {
	super.build_phase(phase);

endfunction // }




task rh_ahbMstDrv::mainProcessTask; // {
	// get next item
	// wait delay
	// if queue valid, then join_none: issue request
	//
	fork
		forever getNextItem();
		forever processControlChannel();
		forever processDataChannel();
	join
endtask // }



`endif
