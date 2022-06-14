`ifndef resetGen_configBase__svh
`define resetGen_configBase__svh

typedef struct {
	resetActive_enum active;
	int activeCycles;
} resetInfo;

class resetGen_configBase extends uvm_object;

	resetInfo resets[string];
    `uvm_object_utils(resetGen_configBase)

    function new(string name="resetGen_configBase");
        super.new(name);
    endfunction

endclass


`endif
