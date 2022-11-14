**tlmPort** name,trans, name->mon.imp
**tlmImp** name,trans, actions:
```
actions for write_tlm ...
```

**instComponent** 
```
TestMonitor#(REQ,RSP) mon
create in build_phase
```
---
```
uvm_analysis_port #(trans) name;

build
	name = new(name);
```

**instObject**
```
TestConfig config
```
