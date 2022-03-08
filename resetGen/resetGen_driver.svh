`ifndef resetGen_driver__svh
`define resetGen_driver__svh

class resetGen_driver #(type REQ=resetGen_trans,RSP=REQ) extends uvm_driver #(REQ,RSP); // {

	resetGen_config cfg;

	`uvm_component_utils_begin(resetGen_driver#(REQ,RSP))
	`uvm_component_utils_end

	function new (string name="resetGen_driver",uvm_component parent=null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task mainProcess;
		seq_item_port.get_next_item(req);
		if (!cfg.resets.exists(req.name)) begin
			`uvm_error(get_type_name(),$sformatf("try to reset a non-existance resetSignal(%s)",req.name))
		end else begin
			if (req.delayCycles) cfg.sync(req.delayCycles);
			cfg.updateActiveCycle(req.name,req.activeCycles);
			cfg.driveResetThroughInterface(req.name);
		end
		seq_item_port.item_done();
	endtask

	task driveInitialResets;
		foreach (cfg.resets[n]) begin
			cfg.driveResetThroughInterface(n);
		end
	endtask

	task run_phase(uvm_phase phase);
		driveInitialResets;
		forever begin
			mainProcess;
		end
	endtask

endclass // }




`endif
