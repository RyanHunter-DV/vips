`ifndef rhGpvMonitor__svh
`define rhGpvMonitor__svh

class RhGpvMonitor extends RhMonitorBase;

	parameter OTRANS = RhGpvTrans;
	parameter ITRANS = RhGpvTrans;


	uvm_analysis_port#(OTRANS) apOutcome;
	uvm_analysis_port#(ITRANS) apIncome;

	`uvm_component_utils_begin(RhGpvMonitor)
	`uvm_component_utils_end

	function new(string name="RhGpvMonitor");
		super.new(name);
	endfunction

	extern virtual function void build_phase(uvm_phase phase);
	extern task mainProcess();

	extern task __outcomeProcess__;
	extern task __incomeProcess__;
endclass
function void RhGpvMonitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	apOutcome = new("apOutcome",this);
	apIncome  = new("apIncome",this);
endfunction
task RhGpvMonitor::__outcomeProcess__;
	OTRANS trans=new("trans");
	protocol.monitorOutcome(trans);
	apOutcome.write(trans);
endtask
task RhGpvMonitor::__incomeProcess__;
	ITRANS trans=new("trans");
	protocol.monitorIncome(trans);
	apIncome.write(trans);
endtask
task RhGpvMonitor::mainProcess();
	fork
		__outcomeProcess__;
		__incomeProcess__;
	join
endtask

`endif