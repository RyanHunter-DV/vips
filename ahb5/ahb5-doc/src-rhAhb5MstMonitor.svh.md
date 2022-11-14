# Features
## support monitoring requests
#TODO 
Monitor the request transaction, each htrans request will be monitored and sent through TLM separately.
There're two type of request transaction will be sent through different request port, one is `reqP`, another is `wreqP`, the `reqP` for all requests that collected at the end of the address phase, not caring about the data, while `wreqP` is specifically for write request, containing the write data.
**tlm-ap** `RhAhb5ReqTrans reqP`
**tlm-ap** `RhAhb5ReqTrans wreqP`

## support monitoring responses
#TODO 
monitor the response transaction, sending response for each htrans, and sends along with the request information. 
**tlm-ap** `RhAhb5RspTrans rspP`
# Source Code
**monitor** `RhAhb5MstMonitor`
**base** `RHMonitorBase`
**field**
```systemverilog
RhAhb5MstConfig config;
```
## reset process
**vtask** `waitResetStateChanged(output RHResetState_enum s)`
**proc**
```systemverilog
logic sig;
config.getResetChanged(sig);
s = RHResetState_enum'(sig);
```
reference:
- [[src-rhAhb5MstConfig.svh#getResetChanged]]
