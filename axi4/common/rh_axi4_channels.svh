`ifndef rh_axi4_channels__svh
`define rh_axi4_channels__svh

class rh_axi4_wchannel#(type REQ=rh_axi4_trans,RSP=REQ) extends uvm_object; // {

    rh_axi4_vip_configBase cfg;

    `uvm_object_utils(rh_axi4_wchannel#(REQ,RSP))

    function new(string name="rh_axi4_wchannel");
        super.new(name);
    endfunction

    extern task drive (ref REQ tr);


endclass // }

class rh_axi4_rchannel#(type REQ=rh_axi4_trans,RSP=REQ) extends uvm_object; // {

    rh_axi4_vip_configBase cfg;

    `uvm_object_utils(rh_axi4_rchannel#(REQ,RSP))
    function new(string name="rh_axi4_rchannel");
        super.new(name);
    endfunction

    // channel drive api, to drive a read request according to coming REQ trans.
    extern task drive (ref REQ tr);
endclass // }




task rh_axi4_wchannel::drive(ref REQ tr); // {
    // TODO
    `placeholder("calling drive, will drive interface signals")
endtask // }

task rh_axi4_rchannel::drive(ref REQ tr); // {
    // TODO
    `placeholder("calling drive, will drive interface signals")
endtask // }


`endif
