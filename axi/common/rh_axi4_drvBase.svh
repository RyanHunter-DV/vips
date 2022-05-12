`ifndef rh_axi4_drvBase__svh
`define rh_axi4_drvBase__svh
class rh_axi4_drvBase#(type REQ=,RSP=) extends uvm_driver#(REQ,RSP);
	rh_axi4_configBase cfg;
	process mainThread;
	uvm_event resetInactive;
	`uvm_component_utils_begin(rh_axi4_drvBase#(REQ,RSP))
		`uvm_field_object(resetInactive,UVM_ALL_ON)
		`uvm_field_object(cfg,UVM_ALL_ON)
	`uvm_component_utils_end
	function new(string name="rh_axi4_drvBase",uvm_component parent=null);
		super.new(name,parent);
	endfunction
	function void build_phase(uvm_phase phase); // {
		super.build_phase(phase);
		resetI=new("resetI",this);
		resetInactive=new("ri");
	endfunction // }
	virtual task mainProcess();
	endtask
	function <return> <name>(<args>);
	<extra>
	endfunction
	task run_phase(uvm_phase phase); // {
		`uvm_info("DEBUG","entering run_phase ...",UVM_LOW)
		forever begin // {
			mainThread = process::self();
			`uvm_info("DEBUG","waiting for resetInactive",UVM_LOW)
			resetInactive.wait_trigger();
			`uvm_info("DEBUG","resetInactive status reached",UVM_LOW)
			mainProcess();
		end // }
	endtask // }
endclass
`endif
