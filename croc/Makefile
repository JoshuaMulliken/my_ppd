.PHONY: build clean

VERSION = 9.5.3
REVISION = 1
OS = linux
DEBIAN_ARCH = armhf
ARCH = arm
ARM_VER = 6


build: build.done

build.done: croc_$(VERSION)-$(REVISION)_$(DEBIAN_ARCH).deb
	touch build.done

croc-$(VERSION).tar.gz:
	wget https://github.com/schollz/croc/archive/refs/tags/v9.5.3.tar.gz -O croc-$(VERSION).tar.gz

croc-$(VERSION): croc-$(VERSION).tar.gz
	tar -xzf croc-$(VERSION).tar.gz

croc-$(VERSION)/croc: croc-$(VERSION)
	cd croc-$(VERSION) && GOOS=$(OS) GOARCH=$(ARCH) GOARM=$(ARM_VER) go build

croc_$(VERSION)-$(REVISION)_$(DEBIAN_ARCH)/usr/local/bin:
	mkdir -p croc_$(VERSION)-$(REVISION)_$(DEBIAN_ARCH)/usr/local/bin

croc_$(VERSION)-$(REVISION)_$(DEBIAN_ARCH)/usr/local/bin/croc: croc_$(VERSION)-$(REVISION)_$(DEBIAN_ARCH)/usr/local/bin croc-$(VERSION)/croc
	cp croc-$(VERSION)/croc croc_$(VERSION)-$(REVISION)_$(DEBIAN_ARCH)/usr/local/bin/croc

croc_$(VERSION)-$(REVISION)_$(DEBIAN_ARCH)/DEBIAN/control:
	mkdir -p croc_$(VERSION)-$(REVISION)_$(DEBIAN_ARCH)/DEBIAN
	echo "Package: croc" > croc_$(VERSION)-$(REVISION)_$(DEBIAN_ARCH)/DEBIAN/control
	echo "Version: $(VERSION)" >> croc_$(VERSION)-$(REVISION)_$(DEBIAN_ARCH)/DEBIAN/control
	echo "Architecture: $(DEBIAN_ARCH)" >> croc_$(VERSION)-$(REVISION)_$(DEBIAN_ARCH)/DEBIAN/control
	echo "Maintainer: Joshua Mulliken <joshua@mulliken.net>" >> croc_$(VERSION)-$(REVISION)_$(DEBIAN_ARCH)/DEBIAN/control
	echo "Description: A command line tool for easily and securely sending things from one computer to another" >> croc_$(VERSION)-$(REVISION)_$(DEBIAN_ARCH)/DEBIAN/control

croc_$(VERSION)-$(REVISION)_$(DEBIAN_ARCH).deb: croc_$(VERSION)-$(REVISION)_$(DEBIAN_ARCH)/DEBIAN/control croc_$(VERSION)-$(REVISION)_$(DEBIAN_ARCH)/usr/local/bin/croc
	dpkg-deb --build --root-owner-group croc_$(VERSION)-$(REVISION)_$(DEBIAN_ARCH)

clean:
	rm -rf build.done croc*