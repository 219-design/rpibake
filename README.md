```bash
init.sh # Install packages needed to perform image creation.
mount.sh # Do packaging via image mounting.
qemu.sh # Do packaging via QEMU.
ssh.sh # SSH into the Raspberry Pi in QEMU.
vars # Variables to use in other scripts.
```

Note that you can't really execute `sudo shutdown` inside QEMU as it will cause a kernel panic and then not end the QEMU process. Instead you have to use `sudo reboot` with the QEMU option `-no-reboot` which causes the QEMU process to exit instead of reboot.

The items in the binary folder are from https://github.com/dhruvvyas90/qemu-rpi-kernel and <https://www.raspberrypi.org/downloads/raspberry-pi-os/> (but you will need to Raspberry Pi OS Lite and extract it yourself).