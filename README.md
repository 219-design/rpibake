# Raspberry Pi Bake

A tool to script the creation of a Raspberry Pi disk images.

Run `./bake` for more information.

## Requirements

[QEMU](https://www.qemu.org/) version 6.2.0 or greater. This can be installed for Ubuntu 22.04 or later with `./bake prerequisites`.

## Example Workflow

Set your SSH keys manually.

```bash
./bake set ssh public $HOME/.ssh/id_rsa.pub
./bake set ssh private $HOME/.ssh/id_rsa
```

Create a script to generate a configured disk image.

```bash
./bake prerequisites # Install pre-requisites other than possibly QEMU.
./bake get ssh public # Verify that this has been set by the user.
./bake get ssh private # Verify that this has been set by the user.
./bake image reset # Pull a Raspberry Pi OS image and overwrite any dirtied copy.
./bake image expand $(( 8 * ( 2 ** 30 ) )) # Make disk 8 GiB.

./bake image mount # Mount the disk image while the disk is offline.

# Extract kernel and dtb files from disk image for native emulation.
# Native emulation has a slower network than versatile but better parallelism.
DIR_BOOT=$(./bake get mount boot) # Get path for the boot partition created in `./bake image mount`
mkdir -p /tmp/qemu
cp -t /tmp/qemu ${DIR_BOOT}/kernel* ${DIR_BOOT}/*.dtb
./bake set native kernel /tmp/qemu/kernel8.img
./bake set native dtb /tmp/qemu/bcm2710-rpi-3-b.dtb

./bake image init # Do initialization to be able to log in via SSH later.
./bake image userpass rpibake bake # Create a file which causes Raspberry Pi OS to create user `rpibake` with passwd `bake`.
./bake image umount # Unmount the disk image.

./bake set user rpibake # Set the user to login with SSH.

./bake qemu raspi3b & # Run QEMU with native emulation in the background. You could also use `./bake qemu versatile &`
local PID_QEMU=$!
./bake wait # Wait until SSH becomes accessible.
# At this point you may choose to upload items over rsync with `./bake rsync ssh ...`
./bake ssh <<EOF
whoami
lsb_release -a
EOF # Pipe in commands over SSH.
./bake halt # SSH in and `sudo reboot` i.e. shutdown the machine.
wait $PID_QEMU # Wait until QEMU has exited.
```

## Caveats

Note that you can't really execute `sudo shutdown` inside QEMU as it will cause a kernel panic and then not end the QEMU process. Instead you have to use `sudo reboot` with the QEMU option `-no-reboot` which causes the QEMU process to exit instead of reboot.