# clockGen VIP

A comprehensive UVM-based Clock Generator Verification IP (VIP) that provides flexible clock generation capabilities for SystemVerilog testbenches. clockGen supports multiple clock signals with configurable frequency, skew, and jitter parameters.

## Features

- **Multiple Clock Support**: Generate and manage multiple independent clock signals
- **Configurable Parameters**: Set frequency, skew, and jitter for each clock
- **Dynamic Clock Control**: Modify clock parameters during simulation
- **UVM Compliant**: Full UVM compliance with proper phasing
- **Interface-based Design**: Clean separation between testbench and DUT
- **Thread-safe**: Support for concurrent clock generation
- **High Performance**: Efficient clock generation with minimal overhead

## Architecture

clockGen VIP consists of the following components:

- **clockGen_uvc**: Main agent component that orchestrates clock generation
- **clockGen_config**: Configuration management for clock parameters
- **clockGen_driver**: Drives clock signals based on configuration
- **clockGen_monitor**: Monitors clock events and provides analysis
- **clockGen_seqr**: Manages clock sequences
- **clockGen_if**: Interface for connecting to DUT clock signals
- **clockGen_trans**: Transaction class for clock events

## File Structure

```
cg/clockGen/
├── clockGen_pkg.sv           # Main package file
├── clockGen_uvc.svh          # Main agent class
├── clockGen_config.svh       # Configuration class
├── clockGen_driver.svh       # Driver component
├── clockGen_monitor.svh      # Monitor component
├── clockGen_seqr.svh         # Sequencer component
├── clockGen_trans.svh        # Transaction class
├── clockGen_if.sv            # Interface definition
├── modulefile                # Environment setup
└── README.md                 # This file
```

## Quick Start

### 1. Import the Package

```systemverilog
// Include clockGen package
import clockGen_pkg::*;
```

### 2. Testbench Setup

```systemverilog
module testbench;
    import uvm_pkg::*;
    import clockGen_pkg::*;
    
    // ClockGen interface
    clockGen_if clk_if();
    
    // Set interface in config_db
    initial begin
        uvm_config_db #(virtual clockGen_if)::set(null, "tb.clk_if", "clockGen_if", clk_if);
    end
    
    // DUT instantiation
    DUT dut(
        .clk0(clk_if.oClk[0]),
        .clk1(clk_if.oClk[1]),
        .clk2(clk_if.oClk[2])
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
    clockGen_uvc cg;
    
    `uvm_component_utils(my_env)
    
    function new(string name = "my_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // Create clockGen agent
        cg = clockGen_uvc::type_id::create("cg", this);
        
        // Set interface path
        cg.setInterfacePath("tb.clk_if");
        
        // Add clocks with frequency, skew, and jitter
        cg.addClock("clk0", 100.0, 0.0, 0.0);    // 100MHz, no skew, no jitter
        cg.addClock("clk1", 50.0, 1.0, 0.5);     // 50MHz, 1ns skew, 0.5ns jitter
        cg.addClock("clk2", 200.0, 0.5, 0.2);    // 200MHz, 0.5ns skew, 0.2ns jitter
    endfunction
    
endclass
```

## Configuration

### Adding Clocks

Use the `addClock()` function to configure clock signals:

```systemverilog
function void addClock(
    string name,     // Clock name identifier
    real freq,       // Frequency in MHz
    real skew = 0,   // Skew in nanoseconds (default: 0)
    real jitter = 0  // Jitter in nanoseconds (default: 0)
);
```

**Parameters:**
- `name`: Unique identifier for the clock signal
- `freq`: Clock frequency in MHz
- `skew`: Clock skew in nanoseconds (can be positive or negative)
- `jitter`: Random jitter in nanoseconds

### Modifying Clock Parameters

You can modify clock parameters during simulation:

```systemverilog
// Change frequency
cg.setFreq("clk0", 150.0);    // Change clk0 to 150MHz

// Change skew
cg.setSkew("clk1", 2.0);      // Change clk1 skew to 2ns

// Change jitter
cg.setJitter("clk2", 1.0);    // Change clk2 jitter to 1ns
```

**Note**: Clock parameter changes must be made before the `end_of_elaboration_phase` completes.

## Usage Examples

### Basic Clock Generation

```systemverilog
// Add a simple 100MHz clock
cg.addClock("sys_clk", 100.0);

// Add a clock with skew and jitter
cg.addClock("pcie_clk", 250.0, 0.5, 0.1);
```

### Multiple Clock Configuration

```systemverilog
// Configure multiple clocks for different domains
cg.addClock("cpu_clk", 2000.0, 0.0, 0.0);      // CPU clock: 2GHz
cg.addClock("mem_clk", 800.0, 1.0, 0.2);       // Memory clock: 800MHz
cg.addClock("io_clk", 100.0, 0.5, 0.1);        // I/O clock: 100MHz
cg.addClock("ref_clk", 25.0, 0.0, 0.0);        // Reference clock: 25MHz
```

### Dynamic Clock Control

```systemverilog
// Initial configuration
cg.addClock("dyn_clk", 100.0, 0.0, 0.0);

// Later in simulation, change parameters
cg.setFreq("dyn_clk", 200.0);   // Double the frequency
cg.setSkew("dyn_clk", 1.0);     // Add 1ns skew
cg.setJitter("dyn_clk", 0.5);   // Add 0.5ns jitter
```

### Clock Synchronization

```systemverilog
// Create synchronized clocks
cg.addClock("master_clk", 100.0, 0.0, 0.0);
cg.addClock("slave_clk", 100.0, 0.0, 0.0);     // Same frequency, no skew

// Or create phase-shifted clocks
cg.addClock("clk_0", 100.0, 0.0, 0.0);         // 0° phase
cg.addClock("clk_90", 100.0, 2.5, 0.0);        // 90° phase (2.5ns delay)
cg.addClock("clk_180", 100.0, 5.0, 0.0);       // 180° phase (5ns delay)
```

## Interface Methods

The `clockGen_if` interface provides utility methods:

```systemverilog
// Get available clock index
int idx = clk_if.getAvailableClockIndex();

// Set half period for a clock
clk_if.setHalfPeriod(0, 100.0, 0.0, 0.0);  // 100MHz, no skew/jitter

// Drive a new clock directly
clk_if.driveNewClock("custom_clk", 50.0, 1.0, 0.5);
```

## Clock Parameters

### Frequency Calculation

The clock period is calculated as:
```
period = 1000 / frequency (in MHz) * 1ns
half_period = period / 2 + skew + jitter
```

### Parameter Ranges

| Parameter | Type | Range | Description |
|-----------|------|-------|-------------|
| `freq` | real | > 0 | Clock frequency in MHz |
| `skew` | real | Any | Clock skew in nanoseconds |
| `jitter` | real | ≥ 0 | Random jitter in nanoseconds |

## Configuration Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `MAXCLKS` | int | 2048 | Maximum number of supported clocks |
| `intfPath` | string | "defaultClockPath" | Interface path in config_db |

## Best Practices

1. **Plan Clock Hierarchy**: Design clock domains and relationships upfront
2. **Use Meaningful Names**: Use descriptive clock names for better debugging
3. **Configure Early**: Set up clocks in build_phase before end_of_elaboration
4. **Monitor Clock Quality**: Use the monitor to verify clock characteristics
5. **Document Requirements**: Document frequency, skew, and jitter requirements
6. **Test Clock Transitions**: Verify behavior during frequency changes

## Error Handling

clockGen provides comprehensive error checking:

```systemverilog
// Invalid clock name
cg.addClock("", 100.0);        // Error: Empty name not allowed
cg.addClock("*", 100.0);       // Error: Wildcard name not allowed

// Duplicate clock name
cg.addClock("clk1", 100.0);
cg.addClock("clk1", 200.0);    // Warning: Clock already exists

// Invalid frequency
cg.addClock("clk2", 0.0);      // Error: Zero frequency not allowed
cg.addClock("clk3", -100.0);   // Error: Negative frequency not allowed
```

## Performance Considerations

- **Clock Limit**: Maximum 2048 clocks supported per interface
- **Thread Management**: Each clock runs in its own thread for efficiency
- **Memory Usage**: Minimal memory footprint per clock
- **Simulation Speed**: Optimized for high-frequency clock generation

## Dependencies

- UVM 1.2 or later
- SystemVerilog IEEE 1800-2012 or later
- Compatible simulator (ModelSim, VCS, Xcelium, etc.)

## Troubleshooting

### Common Issues

1. **Clock Not Starting**: Check interface path and config_db setup
2. **Wrong Frequency**: Verify frequency calculation and units
3. **Timing Issues**: Check skew and jitter parameters
4. **Interface Errors**: Ensure virtual interface is properly set

### Debug Tips

```systemverilog
// Enable UVM debug messages
+UVM_VERBOSITY=UVM_HIGH

// Check clock configuration
foreach (cfg.clockFreqs[clock]) begin
    $display("Clock: %s, Freq: %f MHz", clock, cfg.clockFreqs[clock]);
end
```

## License

This VIP is provided as-is for educational and verification purposes. 