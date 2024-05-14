`ifndef RhQLpiMonitor__svh
`define RhQLpiMonitor__svh

class RhQLpiMonitor#(type REQ=stateTrans_t,RSP=REQ) extends RhVipMonitorBase#(REQ,RSP);

	RhQLpiConfig config;

	uvm_analysis_port #(REQ) reqPort;
	uvm_analysis_port #(RSP) rspPort;

	local state_t currentState;

	`uvm_component_utils_begin(RhQLpiMonitor#(REQ,RSP))
		`uvm_field_object(config,UVM_ALL_ON)
		`uvm_field_enum(state_t,currentState,UVM_ALL_ON)
		// `uvm_field_object(reqPort,UVM_ALL_ON)
		// `uvm_field_object(rspPort,UVM_ALL_ON)
	`uvm_component_utils_end

	function new(string name="RhQLpiMonitor",uvm_component parent=null);
		super.new(name,parent);
	endfunction


	extern virtual function void build();


	// reset action
	extern virtual task waitResetStateChanged(
		input RhResetStateEnum c,
		output RhResetStateEnum s
	);

	// the main process task.
	extern virtual task mainProcess();

	// local API: reqMonitor
	// monitor request actions, of state changed to: QRequest, QContinue, QExit
	extern local task reqMonitor();

	// local API: rspMonitor
	// monitor response actions, mainly for state changed to: QRun, QStopped, QDenied
	extern local task rspMonitor();
	extern local task monitorAccept();
	extern local task monitorDeny();

	// local API: updateCurrentState, to change currentState
	extern local function void updateCurrentState(state_t s);

	// local API to send the transaction from monitor
	extern local task monitorTrans(uvm_analysis_port#(REQ) port,state_t to);
	extern local function void initializeState ();
	extern local task waitResetInactiveSyncd ();
endclass

function void RhQLpiMonitor::initializeState ();
	logic qreqn   = config.getQReqn();
	logic qacceptn= config.getQAcceptn();
	logic qdeny   = config.getQDeny();
	case({qreqn,qacceptn,qdeny})
		'b011: currentState = QDenied;
		'b111: currentState = QContinue;
		'b100: currentState = QExit;
		'b000: currentState = QStopped;
		default: begin
			string msg="cannot recognize init state: ";
			`uvm_warning("INITW",$sformatf("%s{qreqn,qacceptn,qdeny} => {%0b,%0b,%0b}",msg,qreqn,qacceptn,qdeny))
			currentState=config.initState;
		end
	endcase
	return;
endfunction

function void RhQLpiMonitor::updateCurrentState(state_t s);
	currentState = s;
endfunction

task RhQLpiMonitor::reqMonitor();
	// logic c = config.getQReqn();
	state_t to;
	config.waitQReqnNotEqualTo(config.getQReqn());
	case (currentState)
		QRun:     to=QRequest;
		QStopped: to=QExit;
		QDenied:  to=QContinue;
		default: begin
			`uvm_error("QLPI/SERR",$sformatf("QREQn changed in illegal state(%s)",currentState))
			return;
		end
	endcase
	`RhdInfo($sformatf("get QREQn(%0d), state changed to(%s)",config.getQReqn(),to.name()));
	monitorTrans(reqPort,to);
endtask

task RhQLpiMonitor::rspMonitor();
	fork
		monitorAccept();
		monitorDeny();
	join_any
	disable fork;
endtask

task RhQLpiMonitor::monitorAccept();
	state_t to;
	config.waitQAcceptnNotEqualTo(config.getQAcceptn());
	case(currentState)
		QRequest: to = QStopped;
		QExit   : to = QRun;
		default: begin
			`uvm_error("QLPI/SERR",$sformatf("QACCEPTn changed in illegal state(%s)",currentState))
			return;
		end
	endcase
	`RhdInfo($sformatf("get QACCEPTn(%0d), state changed to(%s)",config.getQAcceptn(),to.name()));
	monitorTrans(rspPort,to);
endtask
task RhQLpiMonitor::monitorDeny();
	state_t to;
	config.waitQDenyNotEqualTo(config.getQDeny());
	case(currentState)
		QRequest : to = QDenied;
		QContinue: to = QRun;
		default: begin
			`uvm_error("QLPI/SERR",$sformatf("QDENY changed in illegal state(%s)",currentState))
			return;
		end
	endcase
	`RhdInfo($sformatf("get QDENY(%0d), state changed to(%s)",config.getQDeny(),to.name()));
	monitorTrans(rspPort,to);
endtask

task RhQLpiMonitor::monitorTrans(uvm_analysis_port#(REQ) port,state_t to);
	stateTrans_t tr=new("reqTrans");
	tr.begin_tr();
	tr.from=currentState;
	tr.to  =to;
	updateCurrentState(to);
	tr.end_tr();
	port.write(tr);
	return;
endtask

function void RhQLpiMonitor::build();
	reqPort=new("reqPort",this);
	rspPort=new("rspPort",this);
	currentState=config.initState;
endfunction

task RhQLpiMonitor::waitResetInactiveSyncd ();
	while (RhResetStateEnum'(config.getReset())!=RhResetInactive)
		config.sync(1);
endtask

task RhQLpiMonitor::waitResetStateChanged(
	input RhResetStateEnum c,
	output RhResetStateEnum s
);
	logic csi = logic'(c);

	`RhdInfo($sformatf("wait reset changed, current(%s)",c.name()));
	if (c==RhResetActive) waitResetInactiveSyncd();
	else config.waitResetNotEqualTo(csi);
	s = RhResetStateEnum'(config.getReset());
	`RhdInfo($sformatf("reset changed, to(%s)",s.name()))
	return;
endtask

task RhQLpiMonitor::mainProcess();
	initializeState();
	fork
		forever reqMonitor();
		forever rspMonitor();
	join
endtask


`endif