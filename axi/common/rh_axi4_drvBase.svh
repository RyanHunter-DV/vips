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
	extern virtual task run_phase(uvm_phase phase);

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
	`uvm_info("DEBUG",$sformatf("reset trans got:\n%s",_t.sprint()),UVM_LOW)
	case (_t.reset)
		resetTr_t::inactive: begin
			`uvm_info("DEBUG","resetInactive triggered",UVM_LOW)
			resetInactive.trigger();
		end
		default: begin
			// all other actions are treated as reset active
			`uvm_info("DEBUG","resetInactive reset",UVM_LOW)
			resetInactive.reset();
			mainThreadControl();
		end
	endcase
endfunction // }

function void rh_axi4_drvBase::mainThreadControl(); // {
	`uvm_info("DEBUG","call main thread kill",UVM_LOW)
	if (mainThread == null) return;
	if (mainThread.status() == process::RUNNING) mainThread.kill();
	`uvm_info("DEBUG","main thread kill exit",UVM_LOW)
endfunction // }

task rh_axi4_drvBase::run_phase(uvm_phase phase); // {
	`uvm_info("DEBUG","entering run_phase ...",UVM_LOW)
	forever begin // {
		mainThread = process::self();
		`uvm_info("DEBUG","waiting for resetInactive",UVM_LOW)
		resetInactive.wait_trigger();
		`uvm_info("DEBUG","resetInactive status reached",UVM_LOW)
		mainProcess();
	end // }
endtask // }



`endif
