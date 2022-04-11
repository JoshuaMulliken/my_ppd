REPO_PATH = "debian/dists/bullseye"

clean:
	rm -f $(REPO_PATH)/croc_* $(REPO_PATH)/InRelease $(REPO_PATH)/Packages* $(REPO_PATH)/Release*

build-croc: build-croc-armv6l

build-croc-armv6l:
	cd croc && GOOS=linux GOARCH=arm GOARM=6 go build -o ../croc_9.5.3-1_armv6l/usr/local/bin/croc

package-croc:
	dpkg-deb --build --root-owner-group croc_9.5.3-1_armv6l
	mv croc_9.5.3-1_armv6l.deb $(REPO_PATH)

release-create:
	dpkg-scanpackages --multiversion $(REPO_PATH) > $(REPO_PATH)/Packages
	gzip -k -f $(REPO_PATH)/Packages
	apt-ftparchive release $(REPO_PATH) > $(REPO_PATH)/Release

release-sign:
	gpg --default-key "joshua@mulliken.net" -abs -o - $(REPO_PATH)/Release > $(REPO_PATH)/Release.gpg
	gpg --default-key "joshua@mulliken.net" --clearsign -o - $(REPO_PATH)/Release > $(REPO_PATH)/InRelease