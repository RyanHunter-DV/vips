`ifndef RhQLpiDriver__svh
`define RhQLpiDriver__svh

class RhQLpiDriver#(type REQ=RhQLpiReqTrans,RSP=REQ) extends RhVipDriverBase#(REQ,RSP);

	RhQLpiConfig config;

	`uvm_component_utils_begin(RhQLpiDriver#(REQ,RSP))
	`uvm_component_utils_end

	function new(string name="RhQLpiDriver", uvm_component parent=null);
		super.new(name,parent);
	endfunction

// public
	// main loop
	extern task mainProcess();


// private
	extern local task processPowerControlTrans();
	extern local task processDeviceMode ();
	extern local task drivePowerOffRequest(bit ignoreQActive,int autoPowerUp);
	extern local task drivePowerUpRequest(int autoPowerOff);
	extern local task driveQActiveThread ();
	extern local task driveQRespThread ();
	extern local task driveRandomQActive ();
	extern local task driveResponse (resp_t rsp);
	extern local task releaseResponse (resp_t rsp);
	extern local task waitForQReqValid ();
	extern local task waitForQReqInvalid ();

endclass

task RhQLpiDriver::waitForQReqInvalid ();
	while (config.getQReqn()!==1'b1) begin
		config.sync(1);
	end
endtask

task RhQLpiDriver::driveRandomQActive ();
	`RhdInfo("get random qactive config, drive it randomly")
	forever begin
		config.driveQActive(1'b1);
		config.sync(config.genQActiveCycle());
		config.driveQActive(1'b0);
		config.sync(config.genQActiveCycle());
	end
endtask

task RhQLpiDriver::driveQActiveThread ();
	logic qactive = config.genQActive();
	if  (qactive!==1'bz) config.driveQActive(qactive);
	else driveRandomQActive();
endtask

task RhQLpiDriver::waitForQReqValid ();
	while (config.getQReqn()!==1'b0) begin
		config.sync(1);
	end
endtask
task RhQLpiDriver::driveQRespThread ();
	forever begin
		resp_t rsp;
		waitForQReqValid();
		rsp = config.genResponse();
		driveResponse(rsp);
		config.sync(config.genRespCycle());
		waitForQReqInvalid();
		releaseResponse(rsp);
	end
endtask

task RhQLpiDriver::driveResponse (resp_t rsp);
	case(rsp)
		QLpiAccept: begin
			config.driveQAcceptn(1'b0);
			config.driveQDeny(1'b0); // deny disabled
		end
		QLpiDeny: begin
			config.driveQDeny(1'b1);
			config.driveQAcceptn(1'b1); // qaccept disabled
		end
	endcase
endtask

task RhQLpiDriver::releaseResponse (resp_t rsp);
	case(rsp)
		QLpiAccept: config.driveQAcceptn(1'b1);
		QLpiDeny: config.driveQDeny(1'b0);
	endcase
endtask

task RhQLpiDriver::processDeviceMode ();
	fork
		driveQActiveThread();
		driveQRespThread();
	join
endtask

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

task RhQLpiDriver::processPowerControlTrans();
	seq_item_port.get_next_item(req);
	`RhdInfo($sformatf("getting request from test\n%s",req.sprint()))
	config.sync(req.delay);
	`RhdInfo($sformatf("start driving trans after delay(%0d)",req.delay));
	begin
		int duration=req.lpDuration;
		if (duration==-1) duration=config.genLpDuration();
		`RhdInfo($sformatf("generate lpDuration(%0d)",duration))
		//`RhdInfo($sformatf("active(%0d), 0->drive power off, 1->drive power up",req.active))
		if (req.powerOn==0) drivePowerOffRequest(req.ignoreQActive,duration);
		else drivePowerUpRequest(duration);
	end
	seq_item_port.item_done();
endtask

task RhQLpiDriver::mainProcess();
	// TODO, init after reset, initialize();
	if (config.isDevice==true) processDeviceMode();
	else begin
		// if initState is stop
		forever processPowerControlTrans();
	end
endtask


`endif