# Source Code
**class** `RhAhb5IfControl`
**param** `AW=32,DW=32`
**base** `RhAhb5IfControlBase`

## virtual interface
**field**
```systemverilog
RhAhb5If#(AW,DW) vif;
```

## driveAddressPhase
**vtask** `driveAddressPhase(RhAhb5TransBeat b, bit waitReady)`
**proc**
```systemverilog
bit[AW-1:0] addr = __calculateCurrentAddress__(b);
vif.HADDR  <= addr;

vif.HTRANS <= b.trans;
if (b.trans==RHAHB5_NONSEQ) begin
	vif.HBURST <= b.burst;
	vif.HWRITE <= b.write;
	vif.HSIZE  <= b.size;
	vif.HPROT  <= b.prot;
	vif.HMASTLOCK <= b.lock;
	vif.HMASTER <= b.master;
	vif.HNONSEC <= b.nonsec;
	vif.HEXCL   <= b.excl;
end
if (waitReady) __waitHREADYSyncd__(1);
else @(posedge vif.HCLK);

```
reference:
- [[#waitHREADYSyncd]]
## driveDataPhase
**vtask** `driveDataPhase(ref RhAhb5TransBeat b,output bit isError)`
**proc**
```systemverilog
vif.HWDATA <= b.data[DW-1:0];
fork
	__waitHREADYSyncd__(1);
	__responseError__(isError);
join_any
disable fork;
```
reference:
- [[#responseError]]
## waitDataPhase
**vtask** `waitDataPhase(ref RhAhb5TransBeat b,output bit isError)`
**proc**
```systemverilog
fork
	__waitHREADYSyncd__(1);
	__responseError__(isError);
join_any
disable fork;
```
## waitHREADYSyncd
A task to wait hread to be the target value synchronizely.
**ltask** `__waitHREADYSyncd__(bit val)`
**proc**
```systemverilog
do
	@(posedge vif.HCLK);
while (vif.HREADY !== val);
```
## responseError
detecting HRESP until it gets error, then return; or been killed by disable
**ltask** `__responseError__(output bit e)`
**proc**
```systemverilog
do begin
	@(posedge vif.HCLK);
	e = vif.HRESP[0];
end while (e==1'b0);
```

## getResetChanged
**vtask** `getResetChanged(output logic s)`
```systemverilog
@(vif.HRESETn);
s = vif.HRESETn;
```