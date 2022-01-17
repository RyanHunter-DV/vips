`ifndef rh_ahbDrvBase__svh
`define rh_ahbDrvBase__svh

class rh_ahbDrvBase #(type REQ=rh_ahbTransBase, RSP=REQ)
	extends uvm_driver #(REQ,RSP); // {

	typedef rh_ahbDrvBase#(REQ,RSP) RH_DrvBase;

	process mainThread = null;

	uvm_analysis_imp_reset #(rh_ahbResetTrans,RH_DrvBase) resetI;


	`uvm_component_utils_begin(RH_DrvBase)
	`uvm_component_utils_end

	function new (string name="rh_ahbDrvBase",uvm_component parent=null);
		super.new(name,parent);
	endfunction


	extern virtual function void write_reset(rh_ahbResetTrans _t);
	extern function void resetDriverProcess();
	extern virtual function void userResetProcess();
	extern task mainProcess;
	virtual task activeDriverProcess; endtask

endclass // }

function void rh_ahbDrvBase::resetDriverProcess(); // {
	if (mainThread) mainThread.kill();
	mainThread = null;
	userResetProcess();

endfunction // }

function void rh_ahbDrvBase::write_reset(rh_ahbResetTrans _t); // {
	// triggering reset actions according to reset type
	case (_t.action) // {
		resetActive: begin
			// start reset actions, clear/kill etc.
			resetDriverProcess();
		end
		resetInActive: begin
			// issue a task to start main actions
			fork
				mainProcess;
			join_none
		end
		default: begin end // do nothing
	endcase // }
endfunction // }

task rh_ahbDrvBase::mainProcess; // {
	if (mainThread) return; // if has ongoing thread, then never issue a new one.
	mainThread = process::self();
	forever activeDriverProcess;
endtask // }




`endif
