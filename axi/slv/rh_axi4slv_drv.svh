`ifndef rh_axi4slv_drv__svh
`define rh_axi4slv_drv__svh

class rh_axi4slv_drv extends rh_axi4_drvBase; // {


	`uvm_component_utils_begin(rh_axi4slv_drv)
	`uvm_component_utils_end

	function new(string name="rh_axi4slv_drv", uvm_component parent=null);
		super.new(name,parent);
	endfunction


endclass // }

`endif
