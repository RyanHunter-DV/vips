`ifndef resetGenMonitor__svh
`define resetGenMonitor__svh
class ResetGenMonitor#(type REQ=ResetGenTrans,RSP=REQ) extends uvm_monitor#(REQ,RSP);
	ResetGenConfig config;
	uvm_analysis_port#(REQ) resetP;
	`uvm_component_utils_begin(ResetGenMonitor#(REQ,RSP))
		`uvm_field_object(config,UVM_ALL_ON)
		`uvm_field_object(resetP,UVM_ALL_ON)
	`uvm_component_utils_end
	extern  function  new(string name="ResetGenMonitor",uvm_component parent=null);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
	extern virtual task run_phase(uvm_phase phase);
	extern  task monitorThread(int idx);
endclass



function  ResetGenMonitor::new(string name="ResetGenMonitor",uvm_component parent=null);
	super.new(name,parent);
endfunction
function void ResetGenMonitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	resetP=new("resetP",this);
endfunction
function void ResetGenMonitor::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
endfunction
task ResetGenMonitor::run_phase(uvm_phase phase);
	super.run_phase(phase);
	foreach (config.enables[idx]) begin
		if (config.enables[idx]==0) continue;
		fork monitorThread(idx); join_none
	end
endtask
task ResetGenMonitor::monitorThread(int idx);
	forever begin
		logic o = config.vif.oResetn[idx];
		wait(config.vif.oResetn[idx]!==o);
		o=config.vif.oResetn[idx];
		begin
			REQ tr=new("tr");
			tr.stime=$time;
			tr.index=idx;
			tr.value=o;
			resetP.write(tr);
		end
	end
endtask
`endif
