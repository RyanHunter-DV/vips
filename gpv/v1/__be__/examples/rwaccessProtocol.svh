`ifndef rwaccessProtocol__svh
`define rwaccessProtocol__svh

class RwaccessProtocol#(type OTRANS=RhGpvTrans,ITRANS=OTRANS) extends RhGpvProtocolBase;

	`uvm_object_utils_begin(RwaccessProtocol)
	`uvm_object_utils_end


	function new(string name="RwaccessProtocol");
		super.new(name);
		testname = "RwaccessProtocol";
	endfunction

	// to be deleted, extern virtual function RhGpvDataObj req2dobj(RhGpvTrans req);

	extern function void setupMapping;
	extern virtual task driveTransaction(RhGpvTrans req);
	extern virtual task monitorOutcome(ref OTRANS trans);
	extern virtual task monitorIncome (ref ITRANS trans);
	// extern task waitResetStateChanged (output RhResetState_enum s);
	extern virtual function void corereset (ref string rname,ref string cname);
endclass
function void RwaccessProtocol::corereset(ref string rname,ref string cname); // ##{{{
	rname = "ref_resetn";
	cname = "tb_clk";
endfunction // ##}}}
// task RwaccessProtocol::waitResetStateChanged(output RhResetState_enum s);
// 	logic currentValue = logic'(s);
// 	while (getReset("ref_resetn") === currentValue) sync("tb_clk",1);
// 	s = RhResetState_enum'(getReset("ref_resetn"));
// 	return;
// endtask
task RwaccessProtocol::monitorOutcome(ref OTRANS trans);
	logicVector_t value;
	while(getOutSignal("valid")[0]!==1) sync("tb_clk",1);
	value = getOutSignal("data");
	updateValueToVector("valid",1,trans.vector[0]);
	updateValueToVector("data",value,trans.vector[0]);
	return;
endtask
task RwaccessProtocol::monitorIncome(ref ITRANS trans);
	while(getInSignal("ack")[0]!==1) sync("tb_clk",1);
	updateValueToVector("ack",1,trans.vector[0]);
	return;
endtask
function void RwaccessProtocol::setupMapping;
	RhGpvSignal map = new("valid");
	// setup vector mapping
	map.position(0,0,"vector_out");
	vectormaps.push_back(map);
	map = new("data");
	map.position(1,32,"vector_out");
	vectormaps.push_back(map);
	map = new("ack");
	map.position(33,33,"vector_in");
	vectormaps.push_back(map);
	// setup clock mapping
	map = new("tb_clk");
	map.position(0,0,"clock");
	clockmaps.push_back(map);
	map = new("ref_resetn");
	map.position(0,0,"reset");
	resetmaps.push_back(map);
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
	`uvm_info("DEBUG",$sformatf("start user driveTransaction"),UVM_LOW)
	sync("tb_clk",1);
	`uvm_info("DEBUG",$sformatf("driveSigna(valid/data) => %0h",req.vector[0]),UVM_LOW)
	driveSignal("valid",req.vector[0]);
	driveSignal("data",req.vector[0]);
	`uvm_info("DEBUG",$sformatf("waiting for ack"),UVM_LOW)
	while (getInSignal("ack")[0]!==1) sync("tb_clk",1);
	`uvm_info("DEBUG",$sformatf("ack waited"),UVM_LOW)
	driveSignal("valid",0);
	driveSignal("data",0);
endtask

`endif
