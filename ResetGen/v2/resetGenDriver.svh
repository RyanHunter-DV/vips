`ifndef resetGenDriver__svh
`define resetGenDriver__svh
class ResetGenDriver#(type REQ=ResetGenTrans,RSP=REQ) extends uvm_driver#(REQ,RSP);
	ResetGenConfig config;
	`uvm_component_utils_begin(ResetGenDriver#(REQ,RSP))
		`uvm_field_object(config,UVM_ALL_ON)
	`uvm_component_utils_end
	extern  function  new(string name="ResetGenDriver",uvm_component parent=null);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
	extern virtual task run_phase(uvm_phase phase);
	extern  task mainProcess();
	extern  task driveReset(int index,logic value,realtime stime);
endclass



function  ResetGenDriver::new(string name="ResetGenDriver",uvm_component parent=null);
	super.new(name,parent);
endfunction
function void ResetGenDriver::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction
function void ResetGenDriver::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
endfunction
task ResetGenDriver::run_phase(uvm_phase phase);
	super.run_phase(phase);
	mainProcess();
endtask
task ResetGenDriver::mainProcess();
	forever begin
		seq_item_port.get_next_item(req);
		fork driveReset(req.index,req.value,req.stime) join_none
		seq_item_port.item_done();
	end
endtask
task ResetGenDriver::driveReset(int index,logic value,realtime stime);
	config.vif.oReset[index] = value;
	#stime;
	@(posedge config.vif.refClk[index]);
	config.vif.oReset[index]=config.inactive[index];
endtask
`endif
