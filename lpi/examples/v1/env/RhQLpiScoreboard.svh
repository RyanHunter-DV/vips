`ifndef RhQLpiScoreboard__svh
`define RhQLpiScoreboard__svh
// used for report monitored trans only

`uvm_analysis_imp_decl(_dev0In)
`uvm_analysis_imp_decl(_dev0Out)
`uvm_analysis_imp_decl(_dev1In)
`uvm_analysis_imp_decl(_dev1Out)
`uvm_analysis_imp_decl(_dev2In)
`uvm_analysis_imp_decl(_dev2Out)
`uvm_analysis_imp_decl(_dev3In)
`uvm_analysis_imp_decl(_dev3Out)
`uvm_analysis_imp_decl(_pcIn)
`uvm_analysis_imp_decl(_pcOut)

class RhQLpiScoreboard extends uvm_component;

	typedef RhQLpiScoreboard this_t;
	typedef RhQLpiStateTrans trans_t;

	uvm_analysis_imp_dev0In  #(trans_t,this_t) dev0In;
	uvm_analysis_imp_dev0Out #(trans_t,this_t) dev0Out;
	uvm_analysis_imp_dev1In  #(trans_t,this_t) dev1In;
	uvm_analysis_imp_dev1Out #(trans_t,this_t) dev1Out;
	uvm_analysis_imp_dev2In  #(trans_t,this_t) dev2In;
	uvm_analysis_imp_dev2Out #(trans_t,this_t) dev2Out;
	uvm_analysis_imp_dev3In  #(trans_t,this_t) dev3In;
	uvm_analysis_imp_dev3Out #(trans_t,this_t) dev3Out;

	uvm_analysis_imp_pcIn  #(trans_t,this_t) pcIn;
	uvm_analysis_imp_pcOut #(trans_t,this_t) pcOut;

	`uvm_component_utils_begin(RhQLpiScoreboard)
	`uvm_component_utils_end
// public
	function new(string name="RhQLpiScoreboard",uvm_component parent=null);
		super.new(name,parent);
	endfunction
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
	extern virtual task run_phase(uvm_phase phase);

	extern function void write_dev0In (trans_t tr);
	extern function void write_dev0Out (trans_t tr);
	extern function void write_dev1In (trans_t tr);
	extern function void write_dev1Out (trans_t tr);
	extern function void write_dev2In (trans_t tr);
	extern function void write_dev2Out (trans_t tr);
	extern function void write_dev3In (trans_t tr);
	extern function void write_dev3Out (trans_t tr);
	extern function void write_pcIn (trans_t tr);
	extern function void write_pcOut (trans_t tr);
// private
	extern local function void createPorts ();
endclass

function void RhQLpiScoreboard::write_dev0In (trans_t tr);
	`uvm_info("TESTPORT",$sformatf("get trans from dev0In",tr.sprint()),UVM_LOW)
endfunction
function void RhQLpiScoreboard::write_dev0Out (trans_t tr);
	`uvm_info("TESTPORT",$sformatf("get trans from dev0Out",tr.sprint()),UVM_LOW)
endfunction
function void RhQLpiScoreboard::write_dev1In (trans_t tr);
	`uvm_info("TESTPORT",$sformatf("get trans from dev1In",tr.sprint()),UVM_LOW)
endfunction
function void RhQLpiScoreboard::write_dev1Out (trans_t tr);
	`uvm_info("TESTPORT",$sformatf("get trans from dev1Out",tr.sprint()),UVM_LOW)
endfunction
function void RhQLpiScoreboard::write_dev2In (trans_t tr);
	`uvm_info("TESTPORT",$sformatf("get trans from dev2In",tr.sprint()),UVM_LOW)
endfunction
function void RhQLpiScoreboard::write_dev2Out (trans_t tr);
	`uvm_info("TESTPORT",$sformatf("get trans from dev2Out",tr.sprint()),UVM_LOW)
endfunction
function void RhQLpiScoreboard::write_dev3In (trans_t tr);
	`uvm_info("TESTPORT",$sformatf("get trans from dev3In",tr.sprint()),UVM_LOW)
endfunction
function void RhQLpiScoreboard::write_dev3Out (trans_t tr);
	`uvm_info("TESTPORT",$sformatf("get trans from dev3Out",tr.sprint()),UVM_LOW)
endfunction
function void RhQLpiScoreboard::write_pcIn(trans_t tr);
	`uvm_info("TESTPORT",$sformatf("get trans from pcIn",tr.sprint()),UVM_LOW)
endfunction
function void RhQLpiScoreboard::write_pcOut(trans_t tr);
	`uvm_info("TESTPORT",$sformatf("get trans from pcOut",tr.sprint()),UVM_LOW)
endfunction

function void RhQLpiScoreboard::createPorts ();
	dev0In  = new("dev0In",this);
	dev0Out = new("dev0Out",this);
	dev1In  = new("dev1In",this);
	dev1Out = new("dev1Out",this);
	dev2In  = new("dev2In",this);
	dev2Out = new("dev2Out",this);
	dev3In  = new("dev3In",this);
	dev3Out = new("dev3Out",this);
	pcIn  = new("pcIn",this);
	pcOut = new("pcOut",this);
endfunction

function void RhQLpiScoreboard::build_phase(uvm_phase phase); //##{{{
	super.build_phase(phase);
	createPorts;
endfunction //##}}}
function void RhQLpiScoreboard::connect_phase(uvm_phase phase); //##{{{
	super.connect_phase(phase);
endfunction //##}}}
task RhQLpiScoreboard::run_phase(uvm_phase phase); //##{{{
	super.run_phase(phase);
endtask //##}}}

`endif
