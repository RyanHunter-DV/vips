conf := compileConfig
test := sanityTest
xbuild:
	simf -e 'xcelium.build(:${conf})'
run:
	simf -e 'xcelium.run(:${test})'
sim:
	simf -e 'xcelium.sim(:${test})'

clean:
	rm -rf out/
