conf := masterOnly
test := masterBaseTest
xbuild:
	simf -e 'buildflow(:${conf}).run'

mdbuild:
	mdcs ~/GitHub/Obsidian/vips/ahb5/src/ ./src

run:
	simf -e 'runtest(:${test}).run'
sim:
	simf -e 'runtest(:${test}).sim'

clean:
	rm -rf out/
