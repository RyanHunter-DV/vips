`ifndef ResetGenConfig__svh
`define ResetGenConfig__svh

class ResetAttributes;
/* Description,
	an object that stores reset attributes for the ResetGenConfig table
*/
// public, place holder for public apis and fields
	function new(string n,realtime tu=1ns);
		name = n;
		timeUnit = tu;
	endfunction
// private, place holder for private apis and fields
	string name;
	bit randomInit=1;
	bit activeValue=0;
	bit syncRelease=1;
	ResetPolarity defaultStat;

	// for randomly initialize
	int unsigned maxInitDuration;
	local realtime timeUnit = 1ns;

	// for manually initialize
	realtime initDuration=0ns;
	// genInitDuration -> realtime, 
	// generate a init duration time by given time unit or use the fixed value
	extern  function realtime genInitDuration;
	// getSignalValue(ResetPolarity p) -> bit, 
	// according to the polarity, return the corresponding vector value for the given polarity
	// fo this reset
	extern  function logic getSignalValue(ResetPolarity p);
	// setActiveValue(bit v) -> void, 
	// set this reset's signal value that represent the active stat.
	extern  function void setActiveValue(bit v);
	// convertValueToStat -> ResetPolarity, 
	// according to the given logic value, return the corresponding reset stat
	extern  function ResetPolarity convertValueToStat(logic v);
endclass

function ResetPolarity ResetGenConfig::convertValueToStat(logic v); // ##{{{
	if (v===1'bx || v===1'bz) return ResetUnknown;
	if (v===activeValue) return ResetActive;
	return ResetInactive;

endfunction // ##}}}

function void ResetGenConfig::setActiveValue(bit v); // ##{{{
	activeValue=v;
endfunction // ##}}}

function logic ResetGenConfig::getSignalValue(ResetPolarity p); // ##{{{
	if (p==ResetUnknown) return 'bx;
	if (p==ResetActive) return activeValue;
	else return ~activeValue;
endfunction // ##}}}

function realtime ResetGenConfig::genInitDuration; // ##{{{
	int tnum = 0;
	realtime duration;
	if (!randomInit) return initDuration;
	tnum = $urandom_range(maxInitDuration, 1);
	duration = tnum*timeUnit;
	return duration;
endfunction // ##}}}


//  Class: ResetGenConfig
//
class ResetGenConfig extends uvm_object;

	virtual ResetGenIf vif;

	// field to store the certain reset's active value, legal value can only be 0 or 1.
	ResetAttributes resets[string];

	`uvm_object_utils(ResetGenConfig);

	//  Group: Functions
	// setActiveValue(bit v=0) -> void, a setup config to set the specified
	// reset's active polarity value
	extern function void setActivePolarityValue(string name,bit v=0);

	//  Constructor: new
	function new(string name = "ResetGenConfig");
		super.new(name);
	endfunction: new
	
	//updateInitTable(
	//- string name, ResetPolarity start,
	//- int maxInactiveDuration,
	//- realtime manualInactiveDuration
	//) -> void, 
	// add init table and setup a reset that will be supported by this UVC
	extern  function void updateInitTable(
		string name, ResetPolarity start,
		int maxInactiveDuration=100,realtime timeUnit=1ns,
		realtime manualInactiveDuration=0ns
	);
endclass: ResetGenConfig

function void ResetGenConfig::updateInitTable
	string name, ResetPolarity start,
	int maxInactiveDuration=100,realtime timeUnit=1ns,
	realtime manualInactiveDuration=0ns
); // ##{{{
	if (!resets.exists(name)) resets[name] = new(name,timeUnit);
	resets[name].defaultStat=start;
	if (manualInactiveDuration>0) begin
		resets[name].randomInit=0;
		resets[name].initDuration=manualInactiveDuration;
	end else begin
		resets[name].maxInitDuration= maxInactiveDuration;
	end
endfunction // ##}}}

function void ResetGenConfig::setActivePolarityValue(string name,bit v=0); // ##{{{
	resets[name].setActiveValue(v);
endfunction // ##}}}



`endif