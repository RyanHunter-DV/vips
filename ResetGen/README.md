# ResetGen VIP

A comprehensive UVM-based Reset Generator Verification IP (VIP) that provides flexible reset generation capabilities for SystemVerilog testbenches. ResetGen supports multiple reset signals with configurable polarity, timing, and initialization behavior.

## Features

- **Multiple Reset Support**: Manage multiple reset signals with independent configuration
- **Flexible Polarity**: Support both active-high and active-low reset signals
- **Configurable Initialization**: Random or manual initialization timing
- **UVM Compliant**: Full UVM 1.2 compliance with proper phasing
- **Interface-based Design**: Clean separation between testbench and DUT
- **Comprehensive Monitoring**: Reset event monitoring and analysis
- **Thread-safe**: Support for standalone reset generation threads

## Architecture

ResetGen VIP consists of the following components:

- **ResetGen**: Main agent component that orchestrates reset generation
- **ResetGenConfig**: Configuration management for reset attributes
- **ResetGenDriver**: Drives reset signals based on sequence items
- **ResetGenMonitor**: Monitors reset events and provides analysis
- **ResetGenSeqr**: Manages reset sequences
- **ResetGenIf**: Interface for connecting to DUT reset signals
- **ResetGenTrans**: Transaction class for reset events

## File Structure

```
ResetGen/
├── 3.0/                          # Latest version
│   ├── src/                      # Source files
│   │   ├── ResetGen.svh          # Main agent class
│   │   ├── ResetGenConfig.svh    # Configuration class
│   │   ├── ResetGenDriver.svh    # Driver component
│   │   ├── ResetGenMonitor.svh   # Monitor component
│   │   ├── ResetGenSeqr.svh      # Sequencer component
│   │   ├── ResetGenTrans.svh     # Transaction class
│   │   ├── ResetGenIf.sv         # Interface definition
│   │   ├── ResetGen.sv           # Package file
│   │   └── seqlib/               # Sequence library
│   │       ├── ResetGenBaseSeq.svh
│   │       ├── ResetGenSanityActiveSeq.svh
│   │       └── ResetGenRandomActiveSeq.svh
│   ├── example/                  # Usage examples
│   │   ├── Tb.sv                 # Testbench example
│   │   ├── ResetGenExampleEnv.svh
│   │   └── tests/                # Test examples
│   └── doc/                      # Documentation
└── README.md                     # This file
```

## Quick Start

### 1. Import and Setup

```systemverilog
// Include ResetGen files
`include "ResetGen.svh"
`include "ResetGenConfig.svh"
`include "ResetGenDriver.svh"
`include "ResetGenMonitor.svh"
`include "ResetGenSeqr.svh"
`include "ResetGenTrans.svh"
`include "ResetGenIf.sv"
`include "seqlib/ResetGenBaseSeq.svh"
`include "seqlib/ResetGenSanityActiveSeq.svh"
`include "seqlib/ResetGenRandomActiveSeq.svh"
```

### 2. Testbench Setup

```systemverilog
module testbench;
    import uvm_pkg::*;
    
    // Clock generation
    logic [10:0] clk;
    
    initial begin
        clk = 'h0;
    end
    
    always #1ns clk[0] <= ~clk[0];
    always #2ns clk[1] <= ~clk[1];
    
    // ResetGen interface
    ResetGenIf #(11) rif(.clk(clk));
    
    // Set interface in config_db
    initial begin
        uvm_config_db #(virtual ResetGenIf)::set(null, "tb.rif", "ResetGenIf", rif);
    end
    
    // DUT instantiation
    DUT dut(
        .reset0(rif.reset[0]),
        .reset1(rif.reset[1]),
        .clk0(clk[0]),
        .clk1(clk[1])
    );
    
    // UVM test
    initial begin
        run_test();
    end
    
endmodule
```

### 3. Environment Setup

```systemverilog
class my_env extends uvm_env;
    ResetGen rg;
    
    `uvm_component_utils(my_env)
    
    function new(string name = "my_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // Create ResetGen agent
        rg = ResetGen::type_id::create("rg", this);
        
        // Configure resets
        ResetGenConfig rgc = rg.createConfig();
        rg.setInterfacePath("tb.rif");
        
        // Initialize reset 0: active-low, random init 1-500ns
        rg.init(0, ResetActive, 500);
        
        // Initialize reset 1: active-high, manual init after 200ns
        rg.init(1, ResetActive, 500, 1ns, 200ns);
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        // Set active values for resets
        rg.activeValue(0, 0);  // Reset 0 is active-low
        rg.activeValue(1, 1);  // Reset 1 is active-high
    endfunction
    
endclass
```

## Configuration

### Reset Initialization

The `init()` function configures reset behavior:

```systemverilog
function void init(
    int index,                    // Reset index (0, 1, 2, ...)
    ResetPolarity polarity,       // Initial polarity (ResetActive/ResetInactive)
    int maxInactiveDuration = 200, // Max random init duration
    realtime timeUnit = 1ns,      // Time unit for duration
    realtime manualInactiveDuration = 0ns // Manual init duration
);
```

**Parameters:**
- `index`: Unique identifier for the reset signal
- `polarity`: Initial state (ResetActive = active, ResetInactive = inactive)
- `maxInactiveDuration`: Maximum random initialization time (1 to maxInactiveDuration)
- `timeUnit`: Time unit for duration calculations
- `manualInactiveDuration`: Fixed initialization time (overrides random if > 0)

### Active Value Configuration

Set the active value for each reset signal:

```systemverilog
// Set reset 0 as active-low (active = 0)
rg.activeValue(0, 0);

// Set reset 1 as active-high (active = 1)
rg.activeValue(1, 1);
```

## Usage Examples

### Basic Reset Generation

```systemverilog
// Trigger a reset for 100ns
rg.reset(0, 100ns);
```

### Multiple Reset Coordination

```systemverilog
// Trigger multiple resets with different durations
rg.reset(0, 50ns);   // Reset 0 for 50ns
rg.reset(1, 100ns);  // Reset 1 for 100ns
```

### Custom Sequences

```systemverilog
// Create custom reset sequence
ResetGenSanityActiveSeq seq = new("custom_reset");
seq.add(0, 50ns);   // Reset 0 for 50ns
seq.add(1, 100ns);  // Reset 1 for 100ns
seq.start(rg.sequencer);
```

### Random Reset Generation

```systemverilog
// Use random reset sequence
ResetGenRandomActiveSeq rand_seq = new("random_reset");
rand_seq.start(rg.sequencer);
```

## Reset Polarity Types

```systemverilog
typedef enum int {
    ResetActive,    // Reset is in active state
    ResetInactive,  // Reset is in inactive state
    ResetUnknown    // Reset state is unknown
} ResetPolarity;
```

## Interface Methods

The `ResetGenIf` interface provides utility methods:

```systemverilog
// Synchronize with clock
rif.sync(0, 5);  // Wait 5 cycles on clock 0

// Drive reset signal directly
rif.drive(0, 1);  // Drive reset 0 to value 1

// Wait for reset condition
rif.waitResetNotEqualTo(0, 1);  // Wait until reset 0 != 1

// Get current reset value
logic val = rif.getResetValue(0);  // Get value of reset 0
```

## Monitoring and Analysis

ResetGen provides comprehensive monitoring capabilities:

```systemverilog
class my_env extends uvm_env;
    uvm_analysis_imp #(ResetGenTrans, my_env) reset_imp;
    
    function void write(ResetGenTrans tr);
        `uvm_info("RESET_MON", 
            $sformatf("Reset %0d: %s for %0t", 
                tr.index, 
                tr.stat.name(), 
                tr.duration), 
            UVM_MEDIUM)
    endfunction
endclass
```

## Configuration Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `maxInactiveDuration` | int | 200 | Maximum random initialization time |
| `timeUnit` | realtime | 1ns | Time unit for duration calculations |
| `manualInactiveDuration` | realtime | 0ns | Fixed initialization time |
| `activeValue` | bit | 0 | Active state value (0=active-low, 1=active-high) |

## Best Practices

1. **Initialize Early**: Call `init()` in the build_phase before connect_phase
2. **Set Active Values**: Configure active values in connect_phase
3. **Use Meaningful Indices**: Use consistent index numbering for resets
4. **Monitor Reset Events**: Connect analysis ports to monitor reset behavior
5. **Coordinate Resets**: Plan reset timing to avoid conflicts
6. **Document Configuration**: Document reset polarity and timing requirements

## Dependencies

- UVM 1.2 or later
- SystemVerilog IEEE 1800-2012 or later
- Compatible simulator (ModelSim, VCS, Xcelium, etc.)

## Version History

- **3.0**: Current version with enhanced thread support and improved API
- **2.0**: Previous version with basic reset generation capabilities
- **1.0**: Initial version with fundamental reset functionality

## License

This VIP is provided as-is for educational and verification purposes. 