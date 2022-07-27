`ifndef Axi4Config__svh
`define Axi4Config__svh

class Axi4Config#(`RH_AXI4_INTF_PARAM_DECL) extends Axi4ConfigBase; // {

	Axi4Interface#(`RH_AXI4_INTF_PARAM_MAP) vif;

	`uvm_object_utils_begin(Axi4Config#(`RH_AXI4_INTF_PARAM_MAP))
	`uvm_object_utils_end

	function new(string name="Axi4Config");
		super.new(name);
	endfunction


	extern virtual task drive(string id,ref Axi4ChannelInfo info);
endclass // }


task Axi4Config::drive(string id,ref Axi4ChannelInfo info); // {
	// PLACEHOLDER, auto generated task, add content here
	case (id) // {
		"AWCHANNEL": vif.driveAWChannel(info);
		"WDCHANNEL": vif.driveWDChannel(info);
		"ARCHANNEL": vif.driveARChannel(info);
		"BCHANNEL" : vif.driveBChannel(info);
		"RDCHANNEL": vif.driveRDChannel(info);
		// drive ready signal
		"AWREADY": vif.driveReadySignal("AWREADY",info.awready);
		"WREADY" : vif.driveReadySignal("WREADY",info.wready);
		"ARREADY": vif.driveReadySignal("ARREADY",info.arready);
		"RREADY" : vif.driveReadySignal("RREADY",info.rready);
		"BREADY" : vif.driveReadySignal("BREADY",info.bready);
	endcase // }
endtask // }

`endif
