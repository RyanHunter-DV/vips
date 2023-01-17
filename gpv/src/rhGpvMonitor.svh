`ifndef rhGpvMonitor__svh
`define rhGpvMonitor__svh

class RhGpvMonitor#(type OTRANS=RhGpvTrans,ITRANS=OTRANS) extends RhMonitorBase;

	uvm_analysis_port#(OTRANS) apOutcome;
	uvm_analysis_port#(ITRANS) apIncome;
	RhGpvProtocolBase protocol;
	RhGpvConfig config;

	`uvm_component_utils_begin(RhGpvMonitor)
	`uvm_component_utils_end

	function new(string name="RhGpvMonitor",uvm_component parent=null);
		super.new(name,parent);
	endfunction

	extern virtual function void build_phase(uvm_phase phase);
	extern virtual task waitResetStateChanged (input RhResetState_enum c,output RhResetState_enum s);
	extern task mainProcess();

	extern task __outcomeProcess__;
	extern task __incomeProcess__;
endclass
task RhGpvMonitor::waitResetStateChanged(input RhResetState_enum c,output RhResetState_enum s);
	`uvm_info("DEBUG",$sformatf("call waitResetStateChanged, s:%s",s.name()),UVM_LOW)
	`uvm_info("DEBUG",$sformatf("call waitResetStateChanged, c:%s",c.name()),UVM_LOW)
	protocol.waitResetStateChanged(c,s);
endtask
function void RhGpvMonitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	apOutcome = new("apOutcome",this);
	apIncome  = new("apIncome",this);
	if (!config.resetFeature) resetDisable();
endfunction
task RhGpvMonitor::__outcomeProcess__;
	RhGpvMonitor::OTRANS trans=new("trans");
	protocol.monitorOutcome(trans);
	apOutcome.write(trans);
endtask
task RhGpvMonitor::__incomeProcess__;
	RhGpvMonitor::ITRANS trans=new("trans");
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
