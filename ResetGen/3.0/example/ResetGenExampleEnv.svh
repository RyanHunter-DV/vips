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
	// write(ResetGenTrans tr) -> void, description
	extern  function void write(ResetGenTrans tr);
// private
endclass
function void ResetGenExampleEnv::write(ResetGenTrans tr); // ##{{{
	//TODO
	`uvm_info("TEST",$sformatf("get monitor reset trans:\n%s",tr.sprint()),UVM_LOW)
endfunction // ##}}}

function void ResetGenExampleEnv::build_phase(uvm_phase phase); //##{{{
	super.build_phase(phase);
	rg = ResetGen::type_id::create("rg",this);
	begin
		ResetGenConfig rgc=rg.createConfig();
		rg.setInterfacePath("tb.rif");
		rg.init(0,ResetActive,500);
		rg.init(1,ResetActive,800);
	end
	mImp=new("mImp",this);
endfunction //##}}}
function void ResetGenExampleEnv::connect_phase(uvm_phase phase); //##{{{
	super.connect_phase(phase);
	rg.port.connect(mImp);
endfunction //##}}}
task ResetGenExampleEnv::run_phase(uvm_phase phase); //##{{{
	super.run_phase(phase);
endtask //##}}}

`endif