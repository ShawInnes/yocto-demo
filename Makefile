.DEFAULT_GOAL := help

KAS_CONTAINER ?= kas-container
KAS_FILE ?= kas/qemuarm64.yml

.PHONY: help checkout build shell run clean
help:
	@echo "make checkout  Fetch the pinned Yocto layers"
	@echo "make build     Build the QEMU ARM64 test image"
	@echo "make clean     Remove build output; keep downloads and sstate"
	@echo "make shell     Open the kas build shell"
	@echo "make run       Boot the built image in QEMU (Ctrl-A X to exit)"

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
