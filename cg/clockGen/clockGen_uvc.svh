`ifndef clockGen_uvc__svh
`define clockGen_uvc__svh

class clockGen_uvc extends uvm_agent; // {
	
	clockGen_driver  drv;
	clockGen_monitor mon;
	clockGen_seqr    seqr;
	clockGen_config  cfg;

	`uvm_component_utils_begin(clockGen_uvc)
	`uvm_component_utils_end
	
	function new (string name="clockGen_uvc",uvm_component parent=null);
		super.new(name,parent);
		// create config table
		cfg = clockGen_config::type_id::create("cfg");
	endfunction

	// phases
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);

	// supportive APIs
	extern function void addClock(string name,real freq, real skew=0,real jitter=0);
	extern function void setFreq(string name,real Freq);
	extern function void setJitter(string name,real Jitter);
	extern function void setSkew(string name,real Skew);
	extern function void setInterfacePath(string name);
	// currently not supported, extern function void reset();	

endclass // }

function void clockGen_uvc::setInterfacePath(string name);
	cfg.intfPath = name;
endfunction
		
function void clockGen_uvc::addClock(string name,real freq,real skew=0,real jitter=0); // {
	cfg.addClock(name,freq,skew,jitter);
endfunction // }
`define setClockAttr(attr) \
	if (end_of_elaboration_ph.get_state()<UVM_PHASE_DONE) \
		cfg.set``attr(name,attr); \
	else \
		`uvm_warning( \
			get_type_name(), \
			$sformatf("attempt to set ``attr`` of clock(%s) after end_of_elaboration_phase",name) \
		)
function void clockGen_uvc::setFreq(string name,real Freq); // {
	`setClockAttr(Freq)
endfunction // }
		
function void clockGen_uvc::setJitter(string name,real Jitter); // {
	`setClockAttr(Jitter)
endfunction // }
		
function void clockGen_uvc::setSkew(string name,real Skew); // {
	`setClockAttr(Skew)
endfunction // }
		
function void clockGen_uvc::build_phase (uvm_phase phase); // {
	super.build_phase(phase);
	if (is_active==UVM_ACTIVE) begin // {
		drv = clockGen_driver::type_id::create("drv",this);
		seqr = clockGen_seqr::type_id::create("seqr",this);
		drv.cfg=cfg;
	end // }
	mon = clockGen_monitor::type_id::create("mon",this);
	mon.cfg=cfg;

	// TODO
endfunction // }
		
function void clockGen_uvc::connect_phase(uvm_phase phase); // {
	if (is_active==UVM_ACTIVE)
		drv.seq_item_port.connect(seqr.seq_item_export);
endfunction // }

function void clockGen_uvc::end_of_elaboration_phase(uvm_phase phase); // {
	cfg.elaborateConfigs;
endfunction


`endif
