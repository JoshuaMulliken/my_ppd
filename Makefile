.PHONY: generate-repo
generate-repo: repo.generated

repo.generated: debian/InRelease debian/Release.gpg debian/joshuamulliken_ppa.list
	touch repo.generated

debian/joshuamulliken_ppa.list:
	echo "deb https://joshuamulliken.github.io/my_ppa/debian ./" > debian/joshuamulliken_ppa.list

debian/InRelease: debian/Release.gpg
	@echo "# Please run the following command on the machine with access to the private key:"
	@echo "gpg --clearsign -o - debian/Release > debian/InRelease"
	@exit 1

debian/Release.gpg: debian/Release
	@echo "# Please run the following command on the machine with access to the private key:"
	@echo "gpg -abs -o - debian/Release > debian/Release.gpg"
	@exit 1

debian/Packages: debian croc/build.done
	cp croc/croc*.deb debian
	dpkg-scanpackages -m debian/ > debian/Packages
	gzip -k -f debian/Packages

debian/Release: debian/Packages.gz
	apt-ftparchive release debian/ > debian/Release

croc/build.done:
	cd croc && make $*

debian:
	@echo "# Please create the following directory and files:"
	@echo "- debian/"
	@echo "- debian/KEY.gpg"
	@exit 1

.PHONY: clean
clean:
	rm -rf debian/croc* debian/Packages* debian/Release*
	cd croc && make clean