`ifndef rh_axi4_monBase__svh
`define rh_axi4_monBase__svh

class rh_axi4_monBase extends uvm_monitor;

	uvm_analysis_port #(resetTr_t) resetP;
	rh_axi4_configBase cfg;
	resetTr_t::reset_enum currentResetState;
	process mainThread;

	`uvm_component_utils_begin(rh_axi4_monBase)
		`uvm_field_object(cfg,UVM_ALL_ON)
	`uvm_component_utils_end

	function new(string name="rh_axi4_monBase",uvm_component parent=null);
		super.new(name,parent);
	endfunction

	// phases
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

	// forever threads
	extern task resetDetector;
	extern task mainProcess;
	virtual task runStage; endtask

	// at the initial of starting a run_phase, monitor will send out an unknown reset
	// trans
	extern function void initStart;

	extern local task waitResetStateChange;
	extern local task updateCurrentResetStateToAll;
	extern local function void localkill();

endclass

function void rh_axi4_monBase::build_phase(uvm_phase phase);
	super.build_phase(phase);
	resetP=new("resetP",this);
	currentResetState=resetTr_t::unknown;
endfunction

function void rh_axi4_monBase::initStart;
	resetTr_t tr=new("reset");
	tr.send(currentResetState,$time,resetP);
endfunction

task rh_axi4_monBase::run_phase(uvm_phase phase);
	initStart;
	fork
		resetDetector;
		forever mainProcess;
	join
endtask

task rh_axi4_monBase::mainProcess;
	wait (currentResetState==resetTr_t::inactive);
	mainThread = process::self();
	runStage;
endtask

task rh_axi4_monBase::resetDetector;
	forever begin // {
		`uvm_info("DEBUG","wait for next reset state change",UVM_LOW)
		waitResetStateChange;
		updateCurrentResetStateToAll;
	end // }
endtask

task rh_axi4_monBase::waitResetStateChange;
	cfg.waitResetNotEqualTo(logic'(currentResetState));
	currentResetState = resetTr_t::reset_enum'(cfg.getResetValue());
	`uvm_info("DEBUG",$sformatf("reset state change to %s",currentResetState.name()),UVM_LOW)
endtask

task rh_axi4_monBase::updateCurrentResetStateToAll;
	resetTr_t tr=new("reset");
	if (currentResetState==resetTr_t::active)
		localkill();
	tr.send(currentResetState,$time,resetP);
endtask

function void rh_axi4_monBase::localkill();
	if (mainThread == null) return;
	if (mainThread.status()==process::RUNNING) begin
		mainThread.kill(); mainThread=null;
	end
endfunction


`endif
