# Raspberry Pi Bake

## Setup

[Download Raspberry Pi OS Lite](https://www.raspberrypi.org/downloads/raspberry-pi-os/) and extract the `*.img` file into the binaries folder.

Set the variables in `vars` appropriately.

#### Workflow

If you want to manually modify the disk image the way to do it is to take the vanilla disk image and mount it so that it will automatically configure SSH on the next boot and then run it in QEMU.

```bash
./bake mount
./bake qemu
```

In another terminal you can then SSH into the machine as it is running in QEMU.

```bash
./bake ssh
```

Any other setup from here can rely on being able to pipe commands into SSH.

## Caveats

Note that you can't really execute `sudo shutdown` inside QEMU as it will cause a kernel panic and then not end the QEMU process. Instead you have to use `sudo reboot` with the QEMU option `-no-reboot` which causes the QEMU process to exit instead of reboot.