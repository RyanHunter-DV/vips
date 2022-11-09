```systemverilog
class xxxController#(AW,xxx) extends xxxControlBase
	virtual If#(AW,xxx)

// tb
ahbif#(PARAM) vif(xxx);
controller#(PARAM) = new;
controller.If = vif
uvm_config_set(controlBase)::set(xxx);

```