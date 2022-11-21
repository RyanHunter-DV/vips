`ifndef rhAhb5MstAgent__svh
`define rhAhb5MstAgent__svh

class RhAhb5MstAgent extends uvm_agent;
	uvm_analysis_export #(RhAhb5ReqTrans) reqP;
	uvm_analysis_export #(RhAhb5RspTrans) rspP;
	RhAhb5MstDriver  drv;
	RhAhb5MstMonitor mon;
	RhAhb5MstSeqr    seqr;
	RhAhb5MstConfig config;
	`uvm_component_utils_begin(RhAhb5MstAgent)
	`uvm_component_utils_end
	extern virtual function void build_phase(uvm_phase phase);
	extern function RhAhb5MstConfig createConfig(string name);
	extern function void setupConfigureTable();
	extern function void setupSubComponents();
	extern virtual function void connect_phase(uvm_phase phase);
	extern function  new(string name="RhAhb5MstAgent",uvm_component parent=null);
	extern virtual task run_phase(uvm_phase phase);
endclass
function void RhAhb5MstAgent::build_phase(uvm_phase phase);
	super.build_phase(phase);
	setupConfigureTable();
	setupSubComponents();
endfunction
function RhAhb5MstConfig RhAhb5MstAgent::createConfig(string name);
	config = RhAhb5MstConfig::type_id::create(name);
	return config;
endfunction
function void RhAhb5MstAgent::setupConfigureTable();
	if (!uvm_config_db#(RhAhb5IfControlBase)::get(null,"*",config.interfacePath,config.ifCtrl))
		`uvm_fatal("NIFC","no interface controller get")
endfunction
function void RhAhb5MstAgent::setupSubComponents();
	if (is_active==UVM_ACTIVE) begin
		drv = RhAhb5MstDriver::type_id::create("drv",this);
		drv.config = config;
		seqr= RhAhb5MstSeqr::type_id::create("seqr",this);
	end
	mon = RhAhb5MstMonitor::type_id::create("mon",this);
	mon.config = config;
endfunction
function void RhAhb5MstAgent::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	if (is_active==UVM_ACTIVE) begin
		mon.resetP.connect(drv.resetI);
		drv.seq_item_port.connect(seqr.seq_item_export);
	end
	mon.reqP.connect(reqP);
	mon.rspP.connect(rspP);
endfunction
function  RhAhb5MstAgent::new(string name="RhAhb5MstAgent",uvm_component parent=null);
	super.new(name,parent);
endfunction
task RhAhb5MstAgent::run_phase(uvm_phase phase);
endtask

`endif
