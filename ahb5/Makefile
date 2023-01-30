conf := :omos
test := :omosSanityTest
build:
	simf -e 'xcelium.build(${conf})'
comp:
	simf -e 'xcelium.compile(${test})'
run:
	simf -e 'xcelium.run(${test})'
sim:
	simf -e 'xcelium.sim(${test})'

clean:
	rm -rf out/
