`ifndef ResetGenMonitor__svh
`define ResetGenMonitor__svh

// Component to monitor all reset events from signal according to the config table.
// # Feature lists
// According to registered reset names in config. start a parallel thread to detecting its
// value and once the value is changed, a trans will be sent by the port
class ResetGenMonitor#(type TR=ResetGenTrans) extends uvm_monitor;

	uvm_analysis_port#(TR) port;
	ResetGenConfig config;
	
	`uvm_component_utils_begin(ResetGenMonitor#(TR))
	`uvm_component_utils_end
// public
	function new(string name="ResetGenMonitor",uvm_component parent=null);
		super.new(name,parent);
	endfunction
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual task run_phase(uvm_phase phase);
// private
	// startMonitorOneReset(string name,bit active), 
	// a while looped thread to detect a certain reset information
	// 1.start stat is always the unknown stat.
	// 2.detect if next stat not equals to current
	// 3.update current stat, and record current time, to calculate the duration
	// 4.send a port with reset name by port, send the current stat.
	// 4.build a new trans for this reset name, record current time.
	extern local task startMonitorOneReset(ResetAttributes o);
endclass

function void ResetGenMonitor::build_phase(uvm_phase phase); //##{{{
	super.build_phase(phase);
	port=new("port",this);
endfunction //##}}}

task ResetGenMonitor::startMonitorOneReset(ResetAttributes o); // ##{{{
	ResetPolarity current=ResetUnknown;
	int name = o.name;
	`uvm_info(("MONITOR-DEBUG"),$sformatf("start monitor thread of reset(%s)",name),UVM_HIGH)
	while (1) begin
		logic next;
		TR tr=new("monTr");
		config.vif.waitResetNotEqualTo(name,o.getSignalValue(current));
		next = config.vif.getResetValue(name);
		current = o.convertValueToStat(next);
		tr.etime=$realtime;
		tr.stat=current;
		tr.index=name;
		port.write(tr);
	end
endtask // ##}}}
task ResetGenMonitor::run_phase(uvm_phase phase); //##{{{
	foreach (config.resets[name]) begin
		fork
			startMonitorOneReset(config.resets[name]);
		join_none
	end
endtask //##}}}


`endif