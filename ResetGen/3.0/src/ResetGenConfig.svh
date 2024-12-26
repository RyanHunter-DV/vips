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
	function realtime genInitDuration; // ##{{{
		int tnum = 0;
		realtime duration;
		if (!randomInit) return initDuration;
		tnum = $urandom_range(maxInitDuration, 1);
		duration = tnum*timeUnit;
		return duration;
	endfunction // ##}}}
	// getSignalValue(ResetPolarity p) -> bit, 
	// according to the polarity, return the corresponding vector value for the given polarity
	// fo this reset
	function logic getSignalValue(ResetPolarity p); // ##{{{
		if (p==ResetUnknown) return 'bx;
		if (p==ResetActive) return activeValue;
		else return ~activeValue;
	endfunction // ##}}}
	// setActiveValue(bit v) -> void, 
	// set this reset's signal value that represent the active stat.
	function void setActiveValue(bit v); // ##{{{
		activeValue=v;
	endfunction // ##}}}
	// convertValueToStat -> ResetPolarity, 
	// according to the given logic value, return the corresponding reset stat
	function ResetPolarity convertValueToStat(logic v); // ##{{{
		if (v===1'bx || v===1'bz) return ResetUnknown;
		if (v===activeValue) return ResetActive;
		return ResetInactive;

	endfunction // ##}}}

endclass

//  Class: ResetGenConfig
//
class ResetGenConfig extends uvm_object;

	virtual ResetGenIf vif;

	// field to store the certain reset's active value, legal value can only be 0 or 1.
	ResetAttributes resets[int];

	`uvm_object_utils(ResetGenConfig);

	//  Group: Functions
	// setActiveValue(bit v=0) -> void, a setup config to set the specified
	// reset's active polarity value
	function void setActivePolarityValue(int index,bit v=0); // ##{{{
		resets[index].setActiveValue(v);
	endfunction // ##}}}

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
	function void updateInitTable (
		int index, ResetPolarity start,
		int maxInactiveDuration=100,realtime timeUnit=1ns,
		realtime manualInactiveDuration=0ns
	); // ##{{{
		ResetAttributes attr=new(index,timeUnit);
		if (resets.exists(index))
			`uvm_warning("MULT-INIT",$sformatf("reset %0d already been inited, will replace the old one",index))
		resets[index] = attr;
		attr.defaultStat=start;
		if (manualInactiveDuration>0) begin
			attr.randomInit=0;
			attr.initDuration=manualInactiveDuration;
		end else begin
			attr.maxInitDuration= maxInactiveDuration;
		end
	endfunction // ##}}}

endclass





`endif