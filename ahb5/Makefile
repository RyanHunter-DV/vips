conf := omos
test := omosSanityTest
seed := 246770429
build:
	simf -e 'xcelium.build(:${conf})'
comp:
	simf -e 'xcelium.compile(:${test})'
run:
	simf -e 'xcelium.run(:${test},${seed})'
sim:
	simf -e 'xcelium.sim(:${test},${seed})'

clean:
	rm -rf out/
