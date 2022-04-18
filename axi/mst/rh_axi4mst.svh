`ifndef rh_axi4mst__svh
`define rh_axi4mst__svh

class rh_axi4mst extends uvm_agent; // {

	rh_axi4mst_drv  drv;
	rh_axi4mst_mon  mon;
	rh_axi4mst_seqr seqr;

	`uvm_component_utils_begin(rh_axi4mst)
	`uvm_component_utils_end

	function new(string name="rh_axi4mst", uvm_component parent=null);
		super.new(name,parent);
	endfunction

	// phases
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);


endclass // }

function void rh_axi4mst::build_phase(uvm_phase phase); // {
	mon = rh_axi4mst_mon::type_id::create("mon",this);
	if (is_active==UVM_ACTIVE) begin // {
		drv  = rh_axi4mst_drv::type_id::create("drv",this);
		seqr = rh_axi4mst_seqr::type_id::create("seqr",this);
		drv.setConfigPath(get_full_name());
	end // }
endfunction // }

function void rh_axi4mst::connect_phase(uvm_phase phase); // {
	if (is_active==UVM_ACTIVE) begin // {
		drv.seq_item_port.connect(seqr.seq_item_export);
	end // }
endfunction // }





`endif
