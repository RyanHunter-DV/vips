`ifndef clockGen_config__svh
`define clockGen_config__svh

class clockGen_config extends uvm_object; // {
	
	real clockFreqs[string];
	real clockSkews[string];
	real clockJitters[string];
	
	function new (string name="clockGen_config");
		super.new(name);
	endfunction
	
	extern function void addClock(string name,real freq,real skew,real jitter);
	extern function void setFreq(string name,real freq);
	extern function void setSkew(string name,real skew);
	extern function void setJitter(string name,real jitter);
	
endclass // }


`endif
