`ifndef rh_axi4_driverBase__svh
`define rh_axi4_driverBase__svh

class rh_axi4_driverBase#(type REQ=rh_axi4_trans,RSP=REQ) extends uvm_driver#(REQ,RSP);

	typedef rh_axi4_driverBase#(REQ,RSP) thisClass;

    // reset handler, common for all uvcs/vips
    // TODO
    rh_reset_handler#(resetTr_t) reseth;
    // reset imp, comes from monitor
    uvm_analysis_imp_reset#(resetTr_t,thisClass) resetI;
    rh_axi4_vip_configBase cfg;

	`uvm_component_utils_begin(rh_axi4_driverBase#(REQ,RSP))
	`uvm_component_utils_end

    function new(string name="rh_axi4_driverBase",uvm_component parent=null);
        super.new(name,parent);
    endfunction

	extern task run_phase(uvm_phase phase);
	extern function void build_phase(uvm_phase phase);

	virtual protected task __mainProcess();endtask
	extern function void write_reset(resetTr_t tr);
endclass

function void rh_axi4_driverBase::write_reset(resetTr_t tr); // {
	// PLACEHOLDER, auto generated function, add content here
    reseth.updateResetState(tr);
endfunction // }

function void rh_axi4_driverBase::build_phase(uvm_phase phase); // {
	// PLACEHOLDER, auto generated function, add content here
    reseth = rh_reset_handler#(resetTr_t)::type_id::create("reseth");
    resetI = new("resetI",this);
endfunction // }

task rh_axi4_driverBase::run_phase(uvm_phase phase); // {
	// PLACEHOLDER, auto generated task, add content here
    process mainThread;

    forever begin // {
        mainThread=process::self();
        reseth.threadControl(mainThread);
        __mainProcess();
    end // }
endtask // }

`endif
