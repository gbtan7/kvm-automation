#!/bin/sh
NAME="Neverware-Guest"
VGPU="f50aab10-7cc8-11e9-a94b-6b9d8245bfc1"
MAC="00:DE:AD:BE:EF:F3"
MACHINE="q35"
HDD=/home/vproadmin/vm/disk/neverware1.qcow2
BIOS=/home/vproadmin/vm/fw/OVMF.fd
#IFUP=/home/vproadmin/vm/script/qemu-ifup-bridge
DISPLAY="on"
#SERIAL="stdio"
VGA="none"
VNC=":1"
EGL="egl-headless"
# local tcp socket for controlling vm
MONITOR=7101
DEVPT="-device usb-host,hostbus=1,hostport=2.1 -device usb-host,hostbus=1,hostport=2.2"
