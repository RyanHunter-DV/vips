`ifndef rh_reset_handler__svh
`define rh_reset_handler__svh

class rh_reset_trans extends uvm_sequence_item; // {


    rand rh_reset_status_e st;

    `uvm_object_utils(rh_reset_trans)
    
    function new(string name="rh_reset_trans");
        super.new(name);
    endfunction

endclass // }


class rh_reset_handler #(type TR=rh_reset_trans) extends uvm_object; // {

    rh_reset_status_e currentState;

    `uvm_object_utils(rh_reset_handler#(TR))

    function new(string name="rh_reset_handler");
        super.new(name);
        currentState=rh_reset_unkown;
    endfunction

    extern task threadControl(process p);
    extern local task __detectAndKill(process p);
    extern function void updateResetState(ref TR tr);

endclass // }

task rh_reset_handler::__detectAndKill(process p); // {
    wait(currentState==rh_reset_active);
    if (p==null)
        `uvm_fatal("NOPROC","no main process found while reset active")
    if (p.status()==process::RUNNING)
        p.kill();
endtask // }

task rh_reset_handler::threadControl(process p); // {
    wait(currentState==rh_reset_inactive);
    fork
        __detectAndKill(p);
    join_none
endtask // }

function void rh_reset_handler::updateResetState(ref TR tr);
    currentState=tr.st;
endfunction



`endif
