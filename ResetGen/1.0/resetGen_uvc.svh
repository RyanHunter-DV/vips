`ifndef resetGen_uvc__svh
`define resetGen_uvc__svh

class resetGen_uvc#(MAXRSTS=2048) extends uvm_agent; // {
	
	resetGen_driver  drv;
	resetGen_monitor mon;
	resetGen_seqr    seqr;
	resetGen_config#(MAXRSTS)  cfg;

	`uvm_component_utils_begin(resetGen_uvc#(MAXRSTS))
	`uvm_component_utils_end
	
	function new (string name="resetGen_uvc",uvm_component parent=null);
		super.new(name,parent);
		// create config table
		cfg = resetGen_config#(MAXRSTS)::type_id::create("cfg");
	endfunction

	// phases
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);

	/* supportive APIs */
	// setreset, to set a reset with specific name, nomatter reset exists or not, it will
	// be added to config table
	extern function void setreset(string name,resetActive_enum active=resetGen_activeLow);
	// trigger a reset event, with specific configs:
	// -active cycles:
	// -delaycycles before active: 
	extern function void reset(string name,int ac,int dc=0);

	// set path of the reset interface
	extern function void setInterfacePath(string name);
	

endclass // }

function void resetGen_uvc::reset(string name,int ac,int dc=0);
	resetGen_defaultSeq seq=new("defaultSeq");
	seq.startDefaultReset(name,ac,dc,seqr);
endfunction

function void resetGen_uvc::setInterfacePath(string name);
	cfg.intfPath = name;
endfunction
		
function void resetGen_uvc::setreset(string name,resetActive_enum active=resetGen_activeLow); // {
	cfg.setreset(name,active);
endfunction // }
		
function void resetGen_uvc::build_phase (uvm_phase phase); // {
	super.build_phase(phase);
	if (is_active==UVM_ACTIVE) begin // {
		drv = resetGen_driver::type_id::create("drv",this);
		seqr = resetGen_seqr::type_id::create("seqr",this);
		drv.cfg=cfg;
	end // }
	mon = resetGen_monitor::type_id::create("mon",this);
	mon.cfg=cfg;

endfunction // }
		
function void resetGen_uvc::connect_phase(uvm_phase phase); // {
	if (is_active==UVM_ACTIVE)
		drv.seq_item_port.connect(seqr.seq_item_export);
endfunction // }

function void resetGen_uvc::end_of_elaboration_phase(uvm_phase phase); // {
	cfg.elaborate;
endfunction


`endif
