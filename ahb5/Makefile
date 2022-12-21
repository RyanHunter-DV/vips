conf := masterOnly
xbuild: mdbuild
	simf -e 'buildflow(:${conf}).run'

mdbuild:
	mdcs ~/GitHub/Obsidian/vips/ahb5/src/ ./src

clean:
	rm -rf out/
