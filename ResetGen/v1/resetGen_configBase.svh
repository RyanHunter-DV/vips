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

    virtual function void updateActiveCycle(string n,int ac); endfunction
	// driveResetThroughInterface, the API to call interface tasks to drive a reset event.
	virtual task driveResetThroughInterface(string n); endtask
	virtual task sync(int cyc); endtask

endclass


`endif
