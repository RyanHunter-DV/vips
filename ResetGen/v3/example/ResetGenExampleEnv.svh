`ifndef ResetGenExampleEnv__svh
`define ResetGenExampleEnv__svh

class ResetGenExampleEnv extends uvm_env;

	ResetGen rg;

	uvm_analysis_imp#(ResetGenTrans,ResetGenExampleEnv) mImp;
	
	`uvm_component_utils_begin(ResetGenExampleEnv)
	`uvm_component_utils_end
// public
	function new(string name="ResetGenExampleEnv",uvm_component parent=null);
		super.new(name,parent);
	endfunction
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
	extern virtual task run_phase(uvm_phase phase);
// private
endclass

function void ResetGenExampleEnv::build_phase(uvm_phase phase); //##{{{
	super.build_phase(phase);
	rg = ResetGen::type_id::create("rg",this);
	begin
		ResetGenConfig rgc=rg.createConfig();
		rg.setInterfacePath("tb.rif");
		rg.init("refReset",ResetActive,500);
		rg.init("dutReset",ResetActive,800);
	end
	mImp=new("mImp",this);
endfunction //##}}}
function void ResetGenExampleEnv::connect_phase(uvm_phase phase); //##{{{
	super.connect_phase(phase);
	rg.mPort.connect(mImp);
endfunction //##}}}
task ResetGenExampleEnv::run_phase(uvm_phase phase); //##{{{
	super.run_phase(phase);
endtask //##}}}

`endif