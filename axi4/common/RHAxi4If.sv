`ifndef RHAxi4If__sv
`define RHAxi4If__sv

// interface RHAxi4Interface #(AW=32,DW=32,IW=32,UW=32)
interface RHAxi4If#(`interface_parameter_declare)
(
	input logic ACLK,
	input logic RESETN
); // {

	// write address channel
	logic [AW-1:0] AWADDR;
	logic AWVALID;
	logic AWREADY;
	logic [7:0] AWLEN;
	logic [] AWSIZE;
	logic [] AWBURST;
	logic AWLOCK;
	logic [3:0] AWCACHE;
	logic AWREGION;
	logic [7:0] AWPROT;
	logic [UW-1:0] AWUSER;
	logic [IW-1:0] AWID;

	// write data channel
	logic [IW-1:0] WID;
	logic WVALID;
	logic WREADY;
	logic WLAST;
	logic [DW-1:0] WDATA;
	logic [(DW/8)-1:0] WSTRB;
	logic [UW-1:0] WUSER;

	// write response channel

	// read address channel
	logic [AW-1:0] ARADDR;
	logic ARVALID;
	logic ARREADY;
	logic [7:0] ARLEN;
	logic [] ARSIZE;
	logic [] ARBURST;
	logic ARLOCK;
	logic [3:0] ARCACHE;
	logic ARREGION;
	logic [7:0] ARPROT;
	logic [UW-1:0] ARUSER;
	logic [IW-1:0] ARID;

	// read data channel
	logic [IW-1:0] RID;
	logic RVALID;
	logic RREADY;



	class RHAxi4InterfaceController; // {
		local string name;
		function new(string _n="RHAxi4InterfaceController");
			name = _n;
		endfunction

		function void createConfig();
			uvm_factory.set_type_override_by_type(RHAxi4VipConfigBase::get_type(),RHAxi4VipConfig#(AW,DW,IW,UW)::get_type());
		endfunction
	endclass; // }

	initial begin
		RHAxi4InterfaceController ctrl = new("ctrl");
		ctrl.createConfig();
	end

endinterface // }

`endif
