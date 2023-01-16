`ifndef rhGpvAgent__svh
`define rhGpvAgent__svh

class RhGpvAgent extends uvm_agent;
	parameter type REQ = RhGpvTrans;
	parameter type RSP = RhGpvTrans;

	RhSeqrBase#(REQ,RSP) seqr;

	RhGpvDriever#(REQ,RSP) drv;
	RhGpvMonitor#(REQ,RSP) mon;
	RhGpvConfig  config;
	RhGpvProtocolBase protocol;

	`uvm_component_utils_begin(RhGpvAgent)
	`uvm_component_utils_end


	function new(string name="RhGpvAgent",uvm_component parent=null);
		super.new(name,parent);
	endfunction

	extern function void build_phase(uvm_phase phase);
	extern function RhGpvConfig createConfig(string ifpath);
	extern function void connect_phase(uvm_phase phase);
endclass

function void RhGpvAgent::connect_phase(uvm_phase phase); // ##{{{
	super.connect_phase(phase);
	if (is_active) begin
		drv.seq_item_port.connect(seqr.seq_item_export);
		if (config.resetFeature) mon.resetP.connect(drv.resetI);
	end
endfunction // ##}}}

function RhGpvConfig RhGpvAgent::createConfig(string ifpath);
	config= RhGpvConfig::type_id::create("config");
	config.getInterface(ifpath);
	return config;
endfunction

function void RhGpvAgent::build_phase(uvm_phase phase);
	super.build_phase(phase);

	protocol = RhGpvProtocolBase::type_id::create("protocol",this);
	`uvm_info("DEBUG",$sformatf("protocol name: %s",protocol.testname),UVM_LOW)

	if (is_active) begin
		drv = RhGpvDriever#(REQ,RSP)::type_id::create("drv",this);
		seqr= RhSeqrBase#(REQ,RSP)::type_id::create("seqr",this);
		drv.protocol = protocol;
		drv.config = config;
	end
	mon   = RhGpvMonitor#(REQ,RSP)::type_id::create("mon",this);
	mon.protocol = protocol;
	mon.config = config;
	
	protocol.setup(config);

endfunction


`endif
