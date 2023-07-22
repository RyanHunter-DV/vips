`ifndef RhQLpiDriver__svh
`define RhQLpiDriver__svh

class RhQLpiDriver#(type REQ=RhQLpiReqTrans,RSP=REQ) extends RhVipDriverBase#(REQ,RSP);

	RhQLpiConfig config;

	`uvm_component_utils_begin(RhQLpiDriver#(REQ,RSP))
	`uvm_component_utils_end

	function new(string name="RhQLpiDriver", uvm_component parent=null);
		super.new(name,parent);
	endfunction

	// for build phase
	extern virtual function build();

	// main loop
	extern task mainProcess();
	extern task processOneTrans();
	extern task drivePowerOffRequest(bit ignoreQActive,int autoPowerUp);
	extern task drivePowerUpRequest(int autoPowerOff);

endclass

task RhQLpiDriver::drivePowerUpRequest(int autoPowerOff);
	`RhdInfo($sformatf("driving powerup request, autoPowerOff(%0d)",autoPowerOff));
	config.driveQReqn(1'b1);
	if (autoPowerOff>0) begin
		config.sync(autoPowerOff);
		config.driveQReqn(1'b0);
	end
endtask

task RhQLpiDriver::drivePowerOffRequest(bit ignoreQActive,int autoPowerUp);
	`RhdInfo(
		$sformatf("driving poweroff request, ignoreQActive(%0d), autoPowerUp(%0d)",
		ignoreQActive,autoPowerUp)
	)
	if (!ignoreQActive) config.waitQActiveEqualTo(1'b1);
	config.driveQReqn(1'b0);
	if (autoPowerUp>0) begin
		config.sync(autoPowerUp);
		config.driveQReqn(1'b1);
	end
endtask

task RhQLpiDriver::processOneTrans();
	seq_item_port.get_next_item(req);
	`RhdDump($sformatf("%s",req.sprint()))
	config.sync(req.delay);
	`RhdInfo("start driving trans");
	begin
		int duration=req.lpDuration;
		if (duration==-1) duration=config.genLpDuration();
		if (!config.autoPowerUp) duration=-1;
		if (req.active==0) drivePowerOffRequest(req.ignoreQActive,duration);
		else drivePowerUpRequest(duration);
	end
endtask

task RhQLpiDriver::mainProcess();
	forever begin
		`RhdCall(processOneTrans());
	end
endtask

function void RhQLpiDriver::build();
endfunction


`endif