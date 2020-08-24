#!/bin/sh
NAME="Ubuntu-Guest"
VGPU="f50aab10-7cc8-11e9-a94b-6b9d8245bfc2"
MAC="00:DE:AD:BE:EF:F1"
MACHINE="q35"
HDD=/home/vproadmin/vm/disk/ubuntu.qcow2
#ISO=/home/vproadmin/vm/iso/ubuntu.iso
BIOS=/home/vproadmin/vm/fw/OVMF.fd
#IFUP=/home/vproadmin/vm/script/qemu-ifup-bridge
DISPLAY="on"
VGA="none"
#SERIAL="stdio"
VNC=":1"
EGL="egl-headless"
MONITOR=7110
DEVPT="-device usb-host,hostbus=1,hostport=3.1 -device usb-host,hostbus=1,hostport=3.2"
