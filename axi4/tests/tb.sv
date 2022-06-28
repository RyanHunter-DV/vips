`define INTF_PARAM 32,32,16,16

module DUT;
endmodule

module tb;

    `include "uvm_macros.svh"
    import uvm_pkg::*;


    DUT udut();

	logic tbClk,tbRstn;

	initial begin
		tbClk = 1'b0;
		tbRstn = 1'b0;
		#100ns;
		tbRstn = 1'b1;
	end
	always #5ns tbClk <= ~tbClk;


    bind tb.udut rh_axi4_if#(`INTF_PARAM) mstif(
		.ACLK(tb.tbClk),
		.ARESETN(tb.tbRstn)
        // binding, TODO
    );

    initial begin
        uvm_config_db#(virtual rh_axi4_if#(`INTF_PARAM))::set(null,"tb.udut.mstif","rh_axi4_if",tb.udut.mstif);
    end

    initial begin
        run_test("rh_axi4_test_base");
    end

    // dumpctrl, TODO, from dvlib
    // `include "rh_dumpctrl.svh"
    initial begin
		$shm_open("test.shm");
		$shm_probe(tb,"AS");
        // @RyanH string testname;
        // @RyanH rh_dumpctrl dump;
        // @RyanH $plus$args("+UVM_TESTNAME=%s",testname); // TODO
        // @RyanH dump = new(testname,"fsdb");
        // @RyanH dump.start();
    end

endmodule
