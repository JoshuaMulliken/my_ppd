clean:
	rm -f bullseye/croc_* bullseye/InRelease bullseye/Packages* bullseye/Release*

build-croc: build-croc-armv6l

build-croc-armv6l:
	cd croc && GOOS=linux GOARCH=arm GOARM=6 go build -o ../croc_9.5.3-1_armv6l/usr/local/bin/croc

package-croc:
	dpkg-deb --build --root-owner-group croc_9.5.3-1_armv6l
	mv croc_9.5.3-1_armv6l.deb bullseye

release-create:
	dpkg-scanpackages --multiversion bullseye > bullseye/Packages
	gzip -k -f bullseye/Packages
	apt-ftparchive release bullseye > bullseye/Release

release-sign:
	gpg --default-key "joshua@mulliken.net" -abs -o - bullseye/Release > bullseye/Release.gpg
	gpg --default-key "joshua@mulliken.net" --clearsign -o - bullseye/Release > bullseye/InRelease