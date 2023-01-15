`ifndef rwaccessProtocol__svh
`define rwaccessProtocol__svh

class RwaccessProtocol#(type OTRANS=RhGpvTrans,ITRANS=OTRANS) extends RhGpvProtocolBase;

	`uvm_object_utils_begin(RwaccessProtocol)
	`uvm_object_utils_end


	function new(string name="RwaccessProtocol");
		super.new(name);
	endfunction

	// to be deleted, extern virtual function RhGpvDataObj req2dobj(RhGpvTrans req);

	extern function void setupMapping;
	extern virtual task driveTransaction(RhGpvTrans req);
	extern virtual task monitorOutcome(output OTRANS trans);
	extern virtual task monitorIncome (output ITRANS trans);

endclass
task RwaccessProtocol::monitorOutcome(output OTRANS trans);
	logicVector_t value;
	while(getSignal("valid")!==1) sync("tb_clk",1);
	value = getSignal("data");
	updateValueToVector("valid",1,trans.vector[0]);
	updateValueToVector("data",value,trans.vector[0]);
	return;
endtask
task RwaccessProtocol::monitorIncome(output ITRANS trans);
	while(getSignal("ack")!==1) sync("tb_clk",1);
	updateValueToVector("ack",1,trans.vector[0]);
	return;
endtask
function void RwaccessProtocol::setupMapping;
	RhGpvSignal map = new("valid");
	// setup vector mapping
	map.position(0,0,"vector");
	vectormaps.push_back(map);
	map = new("data");
	map.position(1,32,"vector");
	vectormaps.push_back(map);
	map = new("ack");
	map.position(33,33,"vector");
	vectormaps.push_back(map);
	// setup clock mapping
	map = new("tb_clk");
	map.position(0,0,"clock");
	clockmaps.push_back(map);
endfunction
/* to be deleted
function RhGpvDataObj RwaccessProtocol::req2dobj(RhGpvTrans req);
	RhGpvDataObj dobj=new("dobj");
	foreach (req.mask[i]) begin
		dobj.setDrivePosAndValue(req.mask[i],req.vector[i]);
		dobj.clockIndex = req.clockIndex;
	end
endfunction
*/
task RwaccessProtocol::driveTransaction(RhGpvTrans req);
	sync("tb_clk",1);
	driveSignal("valid",req.vector[0]);
	driveSignal("data",req.vector[0]);
	while (getSignal("ack")!==1) sync("tb_clk",1);
	driveSignal("valid",0);
	driveSignal("data",0);
endtask

`endif
