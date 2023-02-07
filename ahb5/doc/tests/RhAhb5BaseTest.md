
class RhAhb5BaseTest -> uvm_test

# attributes
`int testloop`
- indicates max loop of calling test_sim, can be modified through uvm_config_int
`omosEnv env`
# methods
`- testSim`
- call `testInit`
- call `testConfig`
- call `testRun`
- call `testCheck`
`# testInit`
- initialize the test fields if necessary
`# testConfig`
- env config through 
- rtl config through registers if necessary
`# testRun`
- start runing sequences
`# testCheck`
- checking behavior if has.
`# build_phase`
- create `env`
`# run_phase`
- for loop 0~testloop
- call `testSim`
