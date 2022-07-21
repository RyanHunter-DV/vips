`ifndef RHAxi4Vip__sv
`define RHAxi4Vip__sv

package RHAxi4Vip;

	`include "uvm_macros.svh"
	import uvm_pkg::*;

	`include "common/Axi4Types.svh"
	`include "common/Axi4ConfigBase.svh"
	`include "common/Axi4SeqItem.svh"
	`include "common/Axi4BaseSeq.svh"
	`include "common/Axi4Config.svh"

	`include "common/Axi4MonitorBase.svh"
	`include "common/Axi4DriverBase.svh"
	`include "common/Axi4SeqrBase.svh"
	`include "common/Axi4AgentBase.svh"
	`include "common/Axi4ResponseHandlerBase.svh"

	`include "master/Axi4MasterDriver.svh"
	`include "master/Axi4MasterMonitor.svh"
	`include "master/Axi4MasterSeqr.svh"
	`include "master/Axi4MasterAgent.svh"

	`include "slave/Axi4ResponseHandler.svh"
	`include "slave/Axi4SlaveDriver.svh"
	`include "slave/Axi4SlaveMonitor.svh"
	`include "slave/Axi4SlaveSeqr.svh"
	`include "slave/Axi4SlaveAgent.svh"

	`include "seqlib/Axi4ResponseSeq.svh"

	`include "common/Axi4VipLocalConfig.svh"
	`include "common/Axi4Vip.svh"


	`include "common/anewFile.svh"


endpackage

`include "common/Axi4Interface.sv"

`endif
