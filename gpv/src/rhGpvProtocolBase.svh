`ifndef rhGpvProtocolBase__svh
`define rhGpvProtocolBase__svh

class RhGpvProtocolBase#(type ITRANS=RhGpvTrans,OTRANS=ITRANS) extends uvm_object;

	// parameter ITRANS = RhGpvTrans;
	// parameter OTRANS = RhGpvTrans;


	RhGpvSignal vectormaps[$];
	RhGpvSignal clockmaps[$];
	RhGpvSignal resetmaps[$];

	RhGpvConfig config;
	string testname;

	`uvm_object_utils(RhGpvProtocolBase)

	function new(string name="RhGpvProtocolBase");
		super.new(name);
		testname = "RhGpvProtocolBase";
	endfunction

	function void setup(RhGpvConfig c);
		config = c;
		setupMapping;
	endfunction

	virtual function void setupMapping; endfunction
	virtual task driveTransaction(RhGpvTrans req); endtask
	virtual task monitorOutcome(output OTRANS trans); endtask
	virtual task monitorIncome (output ITRANS trans); endtask

	extern function void driveSignal(string name,logicVector_t vector);
	// the return vector is simply data bits from position 0 to size of the vector
	// nomatter where this signal belongs to in the interface.vector.
	extern function logicVector_t getSignal(string name);
	extern local function RhGpvSignal __getVectorMap__(string name);
	// get the clock position for accessing through interface, according to the
	// input clock name, clock always has 1 bit, so just the start position is enough
	extern local function RhGpvSignal __getClockMap__(string name);
	extern local function RhGpvSignal __getResetMap__ (string name);

	// sync up with specific clock cycle according to the spcified clock name
	extern task sync(string name,int cycle=1);

	// updateValueToVector, to update the data (type: logic[MAX-1:0] value) to the vector position
	// to the giving arg: ref logic[MAX-1:0] vector
	extern function void updateValueToVector(string name,logicVector_t value,ref logicVector_t vector);
	extern virtual function void corereset (ref string rname,ref string cname);
	extern task waitResetStateChanged (RhResetState_enum s);
	extern function logic getReset (string name);
endclass
function void RhGpvProtocolBase::corereset(ref string rname,ref string cname); // ##{{{
	`uvm_warning("RhGpvProtocolBase","no corereset override, it's not expected to happend")
	return;
endfunction // ##}}}
task RhGpvProtocolBase::waitResetStateChanged(RhResetState_enum s);
	string rname,cname;
	logic currentValue = logic'(s);
	corereset(rname,cname);
	while (getReset(rname) === currentValue) sync(cname,1);
	s = RhResetState_enum'(getReset(rname));
	return;
endtask
function void RhGpvProtocolBase::updateValueToVector(
	string name,logicVector_t value,
	ref logicVector_t vector
);

	RhGpvSignal map = __getVectorMap__(name);
	if (map==null) return;
	for (int pos=map.spos;pos<=map.epos;pos++) begin
		vector[pos] = value[pos-map.spos];
	end
	return;
endfunction
function logic RhGpvProtocolBase::getReset(string name); // ##{{{
	RhGpvSignal map = __getResetMap__(name);
	if (map==null) return 'bx;
	return config.getReset(map.spos);
endfunction // ##}}}
function logicVector_t RhGpvProtocolBase::getSignal(string name);
	RhGpvSignal map = __getVectorMap__(name);
	if (map==null) return 'hx;
	return config.getSignal(map.spos,map.epos);
endfunction
task RhGpvProtocolBase::sync(string name,int cycle=1);
	RhGpvSignal map = __getClockMap__(name);
	if (map==null) return;
	config.sync(map.spos,cycle);
endtask

function RhGpvSignal RhGpvProtocolBase::__getVectorMap__(string name);
	foreach (vectormaps[i])
		if (vectormaps[i].get_name()==name) return vectormaps[i];

	`uvm_fatal("NOSIGMAP",$sformatf("signal %s not found in vector map",name))
	return null;
endfunction
function RhGpvSignal RhGpvProtocolBase::__getResetMap__(string name); // ##{{{
	`uvm_info("RhGpvProtocolBase",$sformatf("getting reset from resetmap by name(%s)",name),UVM_LOW)
	foreach (resetmaps[i])
		if (resetmaps[i].get_name()==name) return resetmaps[i];

	`uvm_fatal("NOSIGMAP",$sformatf("signal %s not found in reset map",name))
	return null;
endfunction // ##}}}
function RhGpvSignal RhGpvProtocolBase::__getClockMap__(string name);
	foreach (clockmaps[i])
		if (clockmaps[i].get_name()==name) return clockmaps[i];

	`uvm_fatal("NOSIGMAP",$sformatf("signal %s not found in clock map",name))
	return null;
endfunction

function void RhGpvProtocolBase::driveSignal(string name,logicVector_t vector);
	RhGpvSignal map = __getVectorMap__(name);
	if (map==null) return;
	config.driveVector(map.spos,map.epos,vector);
endfunction

`endif
