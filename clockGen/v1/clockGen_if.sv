`ifndef clockGen_if__sv
`define clockGen_if__sv

`define MAXCLKS 2048

// freq here is in MHz
interface clockGen_if (); // {

	logic [`MAXCLKS-1:0] oClk;

	int clockIndex[string];
	real freqs[int];
	real skews[int];
	real jitters[int];
	real halfPeriods[int];
	process clockThread[string];


	task automatic alwaysDriveClock(int clockI); // {
		realtime hp;
		hp =halfPeriods[clockI]/1ns;
		oClk[clockI] = 1'b0; // clock init
		forever begin
			#hp;
			oClk[clockI]<= ~oClk[clockI];
		end
	endtask // }


	function int getAvailableClockIndex(); // {
		static int aIndex = 0;
		aIndex++; // increment, then return the value before incremental.
		return (aIndex-1);
	endfunction // }

	function void setHalfPeriod(int index,real freq,real skew,real jitter);
		real period;
		real halfP;
		period = 1000/freq*1ns;
		halfP = period/2+skew+jitter;
		halfPeriods[index]=halfP;
	endfunction

	task changeClockFreq(); // {
		// TODO
	endtask // }

	task automatic driveNewClock(string name,real freq,real skew,real jitter); // {
		if (clockIndex.exists(name)) return;
		clockIndex[name] = getAvailableClockIndex();
		setHalfPeriod(clockIndex[name],freq,skew,jitter);
		fork
			begin
				clockThread[name] = process::self();
				alwaysDriveClock(clockIndex[name]);
			end
		join_none
	endtask // }

endinterface // }


`endif
