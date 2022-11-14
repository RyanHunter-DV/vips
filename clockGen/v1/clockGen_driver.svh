`ifndef clockGen_driver__svh
`define clockGen_driver__svh

class clockGen_driver #(type REQ=clockGen_trans,RSP=REQ) extends uvm_driver #(REQ,RSP); // {

	clockGen_config cfg;

	`uvm_component_utils_begin(clockGen_driver#(REQ,RSP))
	`uvm_component_utils_end

	function new (string name="clockGen_driver",uvm_component parent=null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task mainProcess;
		seq_item_port.get_next_item(req);
		cfg.driveClockThroughInterface(
			req.name,
			req.freq,
			req.skew,
			req.jitter
		);
		seq_item_port.item_done();
	endtask

	task driveInitialClocks;
		foreach (cfg.clockFreqs[clock]) begin
			cfg.driveClockThroughInterface(
				clock,
				cfg.clockFreqs[clock],
				cfg.clockSkews[clock],
				cfg.clockJitters[clock]
			);
		end
	endtask

	task run_phase(uvm_phase phase);
		driveInitialClocks;
		forever begin
			mainProcess;
		end
	endtask

endclass // }




`endif
