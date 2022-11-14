`ifndef rh_axi4_mst_agent__svh
`define rh_axi4_mst_agent__svh

class RHAxi4MstAgent extends uvm_agent; // {

	RHAxi4MstDriver     drv;
	RHAxi4MstMonitor    mon;
	RHAxi4MstSeqr       seqr;
	RHAxi4MstConfig     config;

	function new(string name="RHAxi4MstAgent",uvm_component parent=null);
		super.new(name,parent);
	endfunction

	
	extern function void build_phase(uvm_phase phase);

endclass // }

function void RHAxi4MstAgent::build_phase(uvm_phase phase); // {
	// PLACEHOLDER, auto generated function, add content here
	if (is_active == UVM_ACTIVE) begin
	end
endfunction // }

`endif
