.DEFAULT_GOAL := help

KAS_CONTAINER ?= kas-container
KAS_FILE ?= kas/qemuarm64.yml

.PHONY: help checkout build shell run clean build-rock3b shell-rock3b
help:
	@echo "make checkout      Fetch the pinned Yocto layers"
	@echo "make build         Build the QEMU ARM64 test image"
	@echo "make build-rock3b  Build the ROCK 3B image (unvalidated)"
	@echo "make shell-rock3b  Open the ROCK 3B build shell"
	@echo "make clean         Remove build output; keep downloads and sstate"
	@echo "make shell         Open the kas build shell"
	@echo "make run           Boot the built image in QEMU (Ctrl-A X to exit)"

checkout:
	$(KAS_CONTAINER) checkout $(KAS_FILE)

build:
	$(KAS_CONTAINER) build $(KAS_FILE)

shell:
	$(KAS_CONTAINER) shell $(KAS_FILE)

run:
	$(KAS_CONTAINER) shell $(KAS_FILE) -c 'runqemu tmp/deploy/images/qemuarm64/core-image-demo-qemuarm64.rootfs.wic nographic slirp qemuparams="-snapshot"'

clean:
	$(KAS_CONTAINER) clean $(KAS_FILE)

build-rock3b:
	$(MAKE) build KAS_FILE=kas/rock-3b.yml

shell-rock3b:
	$(MAKE) shell KAS_FILE=kas/rock-3b.yml
