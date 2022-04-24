`ifndef rh_axi4_drvBase__svh
`define rh_axi4_drvBase__svh

class rh_axi4_drvBase #(type REQ=rh_axi4_trans,RSP=REQ) extends uvm_driver#(REQ,RSP); // {

	uvm_analysis_imp_rhaxi4_reset#(resetTr_t,rh_axi4_drvBase#(REQ,RSP)) resetI;

	rh_axi4_configBase cfg;
	process mainThread;
	uvm_event resetInactive;


	`uvm_component_utils_begin(rh_axi4_drvBase#(REQ,RSP))
		`uvm_field_object(resetInactive,UVM_ALL_ON)
		`uvm_field_object(cfg,UVM_ALL_ON)
	`uvm_component_utils_end

	function new(string name="rh_axi4_drvBase",uvm_component parent=null);
		super.new(name,parent);
	endfunction


	// phases
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

	// imp actions
	extern function void write_reset(resetTr_t _t);

	// internal actions
	extern function void mainThreadControl();

	// for sub-classes
	virtual task mainProcess(); endtask

	// APIs

endclass // }


function void rh_axi4_drvBase::build_phase(uvm_phase phase); // {
	super.build_phase(phase);
	resetI=new("resetI",this);
	resetInactive=new("ri");
endfunction // }

function void rh_axi4_drvBase::write_reset(resetTr_t _t); // {
	case (_t.reset)
		resetTr_t::inactive: begin
			resetInactive.trigger();
		end
		default: begin
			// all other actions are treated as reset active
			resetInactive.reset();
			mainThreadControl();
		end
	endcase
endfunction // }

function void rh_axi4_drvBase::mainThreadControl(); // {
	if (mainThread == null) return;
	if (mainThread.status() == process::RUNNING) mainThread.kill();
endfunction // }

task rh_axi4_drvBase::run_phase(uvm_phase phase); // {
	fork
		forever begin // {
			resetInactive.wait_on();
			mainThread = process::self();
			mainProcess();
		end // }
	join
endtask // }



`endif
