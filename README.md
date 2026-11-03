# QEMU ARM64 RAUC test

A Yocto Scarthgap image with systemd, SSH and RAUC. The disk contains an
EFI boot partition, rootfs A, an empty rootfs B, and a persistent data partition.

Requires Linux, Git, Make, a running Docker (or Podman), and `kas-container`
on your PATH. Run as your normal user with access to the container engine.
Allow plenty of disk space (about 100 GB) and time for the first build.
For Podman, set `KAS_CONTAINER_ENGINE=podman`.

```sh
make build       # fetch pinned layers and build core-image-demo
make run         # boot with software emulation and user-mode networking
```

Log in as `root` with no password. Exit QEMU with **Ctrl-A, X**.
The QEMU image enables passwordless root for testing only.
`make run` uses a snapshot: guest changes are discarded when QEMU exits.

Inside the guest:

```sh
cat /proc/cmdline
mount
rauc status
```

The kernel command line selects RAUC slot A. This is a build/boot smoke test;
RAUC uses its `noop` bootloader backend. Automatic A/B switching and signed
update bundles are not configured. The QEMU runner loads the kernel directly;
it does not test the EFI boot chain. `rauc status` may warn that `noop` cannot
report the primary slot.

Outputs: `build/tmp/deploy/images/qemuarm64/` (`core-image-demo-qemuarm64.rootfs.wic`
and its `.wic.bmap`, plus the kernel and QEMU configuration).

```sh
make checkout    # fetch layers without building
make shell       # open the BitBake environment
make clean       # remove build output, keeping downloads and sstate
make help
```

Equivalent build command: `kas-container build kas/qemuarm64.yml`.
Override the executable with `make KAS_CONTAINER=/path/to/kas-container build`.

Repository contents:

- `Makefile`, `README.md`, `.gitignore`: commands, instructions and ignore rules.
- `kas/`: build configurations and the commit lockfile. Keep the lockfile for
  reproducible layer checkouts; `rock-3b.yml` retains the hardware configuration.
- `meta-demo/`: our Yocto layer, image recipe, disk layout, machine-specific
  fstab/RAUC settings and the public test keyring required by the image.

kas downloads `poky/` and the external `meta-*` layers. These are ignored local
checkouts, not submodules. Build output, caches and kas shell history are also
ignored. `pki/` is unused local signing material and is excluded; the image uses
`meta-demo/recipes-core/rauc/files/keyring.pem`. Empty `app/` and `ci/` directories
contain no repository files. Do not commit generated images or private keys.
