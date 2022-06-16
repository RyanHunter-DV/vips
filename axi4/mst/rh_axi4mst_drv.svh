`ifndef rh_axi4mst_drv__svh
`define rh_axi4mst_drv__svh

class rh_axi4mst_drv #(type REQ=rh_axi4_trans,RSP=REQ) extends uvm_driver#(REQ,RSP); // {

    typedef rh_axi4mst_drv#(REQ,RSP) thisClass;


    // reset handler, common for all uvcs/vips
    // TODO
    rh_reset_handler#(resetTr_t) reseth;

    rh_axi4_vip_configBase cfg;
    RSP rspQue[$];

    // uvm header
    // TODO
    `uvm_component_utils_begin(rh_axi4mst_drv#(REQ,RSP))
    `uvm_component_utils_end


    function new(string name="rh_axi4mst_drv",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    // uvm phase
    // TODO
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);



    // reset imp, comes from monitor
    uvm_analysis_imp_reset#(resetTr_t,thisClass) resetI;
    // write response imp, if configured as respEn=TRUE, then response will be sent to
    // response queue. trans comes from monitor.
    // read response imp, from monitor, if conigured respEn=TRUE, then response will be sent to
    // response queue.
    // TODO
    uvm_analysis_imp_resp#(RSP,thisClass) respI;

    // write address drive channel
    // TODO
    rh_axi4_wchannel#(REQ,RSP) wChnl;

    // read address drive channel
    // TODO
    rh_axi4_rchannel#(REQ,RSP) rChnl;

    extern task mainProcess();
    extern task waitForResponse(ref REQ _req,ref RSP _rsp);

    // TLM apis
    extern function void write_reset(resetTr_t tr);
    extern function void write_resp(RSP tr);

endclass // }

// driver component built up.
//
function void rh_axi4mst_drv::build_phase(uvm_phase phase); // {
    reseth = rh_reset_handler#(resetTr_t)::type_id::create("reseth");
    resetI = new("resetI",this);
    respI  = new("respI",this);
    wChnl = rh_axi4_wchannel#(REQ,RSP)::type_id::create("wChnl");
    rChnl = rh_axi4_rchannel#(REQ,RSP)::type_id::create("rChnl");
endfunction // }

function void rh_axi4mst_drv::connect_phase(uvm_phase phase); // {
    wChnl.cfg = cfg;
    rChnl.cfg = cfg;
    // TODO
    //wdChnl.setBeatsDelay(cfg.wdBeatsDelay_min,cfg.wdBeatsDelay_max);
    //wdChnl.set_wa2wdDelay(cfg.wa2wdDelay_min,cfg.wa2wdDelay_max);
endfunction // }

task rh_axi4mst_drv::run_phase(uvm_phase phase); // {
    process mainThread;

    forever begin // {
        mainThread=process::self();
        reseth.start(mainThread);
        mainProcess();
    end // }
endtask // }

function void rh_axi4mst_drv::write_reset(resetTr_t tr); // {
    reseth.updateResetState(tr);
endfunction // }

function void rh_axi4mst_drv::write_resp(RSP tr); // {
    // bresp or rresp
    if (cfg.respEn) rspQue.push_back(tr);
endfunction // }

task rh_axi4mst_drv::waitForResponse(ref REQ _req,ref RSP _rsp); // {
    bit matched = 0;
    RSP _tmp = null;
    _rsp.set_id_info(_req);
    _rsp.copy(_req);
    // TODO, response may occur later then other responses whose request is sent after the req that is currently
    // waiting for
endtask // }


task rh_axi4mst_drv::mainProcess(); // {
    seq_item_port.get_next_item(req);
    case (req.t) // {
        rhaxi4_write_req: begin
            wChnl.drive(req);
        end
        rhaxi4_read_req: begin
            rChnl.drive(req);
        end
    endcase // }
    if (cfg.respEn) begin
        waitForResponse(req,rsp);
        seq_item_port.item_done(rsp);
    end else
        seq_item_port.item_done();
endtask // }

`endif
