testname := +UVM_TESTNAME=rhaxi4_testBase
ts := -timescale 1ns/1ps

auto:
	cp filelist out/;cd out;xrun -64bit -sv -access rwc -uvm -f filelist ${testname} ${ts} +UVM_TIMEOUT=1000ns
na:
	cp filelist out/;cd out;xrun -64bit -sv -access rwc -uvmnoautocompile -f filelist +UVM_TESTNAME=rhaxi4_testBase
