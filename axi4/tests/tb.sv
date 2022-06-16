`define INTF_PARAM 32,32,16,16

module tb;

    `include "uvm_macros.svh"
    import uvm_pkg::*;


    DUT udut();


    bind tb.udut rh_axi4_if#(`INTF_PARAM) mstif(
        // binding, TODO
    );

    initial begin
        uvm_config_db#(virtual rh_axi4_if)::set(null,"tb.mstif","rh_axi4_if",mstif)
    end

    initial begin
        run_test();
    end

    // dumpctrl, TODO, from dvlib
    `include "rh_dumpctrl.svh"
    initial begin
        string testname;
        rh_dumpctrl dump;
        $plus$args("+UVM_TESTNAME=%s",testname); // TODO
        dump = new(testname,"fsdb");
        dump.start();
    end

endmodule
