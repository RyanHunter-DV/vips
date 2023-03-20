`ifndef resetGenAgent__svh
`define resetGenAgent__svh
class ResetGenAgent extends uvm_agent;
	ResetGenConfig config;
	ResetGenDriver drv;
	ResetGenSeqr seqr;
	ResetGenMonitor mon;
	`uvm_component_utils_begin(ResetGenAgent)
		`uvm_field_object(config,UVM_ALL_ON)
		`uvm_field_object(drv,UVM_ALL_ON)
		`uvm_field_object(seqr,UVM_ALL_ON)
		`uvm_field_object(mon,UVM_ALL_ON)
	`uvm_component_utils_end
	extern  function  new(string name="ResetGenAgent",uvm_component parent=null);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
	extern virtual task run_phase(uvm_phase phase);
	extern  function ResetGenConfig createConfig(string ifPath);
	extern  function void init(int idx,logic val,logic ia,realtime _t);
endclass



function  ResetGenAgent::new(string name="ResetGenAgent",uvm_component parent=null);
	super.new(name,parent);
endfunction
function void ResetGenAgent::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if (is_active==UVM_ACTIVE) begin
		drv =ResetGenDriver::type_id::create("drv",this);
		seqr=ResetGenSeqr::type_id::create("drv",this);
		drv.config=config;
	end
	mon=ResetGenMonitor::type_id::create("mon",this);
	mon.config=config;
endfunction
function void ResetGenAgent::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	if(is_active==UVM_ACTIVE) begin
		drv.seq_item_prot.connect(seqr.seq_item_export);
	end
endfunction
task ResetGenAgent::run_phase(uvm_phase phase);
	super.run_phase(phase);
endtask
function ResetGenConfig ResetGenAgent::createConfig(string ifPath);
	config=ResetGenConfig::type_id::create("config");
	if(!uvm_config_db#(virtual ResetGenIf)::get(null,ifPath,"ResetGenIf",config.vif))
		`uvm_fatal("NOVIF",$sformatf("cannot get interface with path: %s",ifPath))
	return config;
endfunction
function void ResetGenAgent::init(int idx,logic val,logic ia,realtime _t);
	string path = {this.get_full_name(),".seqr.run_phase"};
	config.enable(idx,ia);
	ResetGenSeq seq=new("seq");
	seq.stime=_t;
	seq.value=val;
	seq.index=idx;
	uvm_config_db::(uvm_sequence_base)::set(null,path,"default_sequence",seq);
endfunction
`endif
