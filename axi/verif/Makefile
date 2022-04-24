testname := +UVM_TESTNAME=rhaxi4_testBase

auto:
	cp filelist out/;cd out;xrun -64bit -sv -access rwc -uvm -f filelist ${testname}
na:
	cp filelist out/;cd out;xrun -64bit -sv -access rwc -uvmnoautocompile -f filelist +UVM_TESTNAME=rhaxi4_testBase
