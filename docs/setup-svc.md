# Setting up services

In order to have KVM guest OS properly running with GVTg GPU, we need to have several services in order:
* VGPU service
* Guest OS service

Both services requires configuration which will be defined in an executable script file called /var/vm/scripts/env/sh
```
#!/bin/bash
# Note: VGPU ports mask setting must be done before any VGPU is created
# VGPU to PORT assignment
# 1 -> PORT_A (can't be used because special eDP case: WIP to resolve)
# 2 -> PORT_B
# 3 -> PORT_C
# 4 -> PORT_D
MASK=0x0000000000000402

# BKM: To generate UUID, use uuid command.
# For ease of identification, replicate and replace the last number with VGPU index
VGPU1="f50aab10-7cc8-11e9-a94b-6b9d8245bfc1"
VGPU2="f50aab10-7cc8-11e9-a94b-6b9d8245bfc2"
VGPU3="f50aab10-7cc8-11e9-a94b-6b9d8245bfc3"
VGPU=" $VGPU1 $VGPU2 $VGPU3 "
VGPU_TYPE="i915-GVTg_V5_4"
BASEVGPU="/sys/bus/pci/devices/0000:00:02.0"
DIR="/var/vm"
```

## VGPU service

VGPU service is responsible for defining display mapping and creation of VGPU. There will be two scripts provided to support the execution of VGPU service, one for creation and one for destruction of VGPUs.

File (executable): /var/vm/scripts/create-vgpu.sh
```
#!/bin/bash
envconfig="/var/vm/scripts/env.sh"
if [[ $EUID -ne 0 ]]; then
        echo "This script must be run by superuser."
        exit 1
fi

if [ -f $envconfig ]; then
        source $envconfig
else
        echo "Could not find necessary environment setting."
        exit 1
fi
# Setting VGPU mask
/bin/sh -c "echo $MASK > /sys/class/drm/card0/gvt_disp_ports_mask"
# iterate through vgpu uuid and create uuid
for uuid in $VGPU
do
        /bin/sh -c "echo $uuid > ${BASEVGPU}/mdev_supported_types/${VGPU_TYPE}/c
reate"
done
```

File (executable): /var/vm/scripts/destroy-vgpu.sh
```
#!/bin/bash
envconfig="/var/vm/scripts/env.sh"
if [[ $EUID -ne 0 ]]; then
        echo "This script must be run by superuser."
        exit 1
fi

if [ -f $envconfig ]; then
        source $envconfig
else
        echo "Could not find necessary environment setting."
        exit 1
fi
# iterate through vgpu uuid and create uuid
for uuid in $VGPU
do
        if [ -f "${BASEVGPU}/${uuid}/remove" ]; then
                /bin/sh -c "echo 1 > ${BASEVGPU}/${uuid}/remove"
        else
                echo "VGPU ${uuid} does not exist."
        fi
done
```

The VGPU service file itself is below:
File:/etc/systemd/system/vgpu.service
```
[Unit]
Description=Create GVTg VGPU
# This unit creates 3 virtual GPUs with the UUIDs below.
# It also set the port map mask to 0 which disables direct display pipe to port map.
ConditionPathExists=/sys/bus/pci/devices/0000:00:02.0/mdev_supported_types
ConditionPathExists=/var/vm/scripts/env.sh
[Service]
Type=oneshot
RemainAfterExit=true
EnvironmentFile=/var/vm/scripts/env.sh
ExecStart=/var/vm/scripts/create-vgpu.sh
ExecStop=/var/vm/scripts/destroy-vgpu.sh
[Install]
WantedBy=multi-user.target
```
Once the files are located in place withe the right permission (i.e. executable), we can enable the VGPU service.
```
$ sudo systemctl enable vgpu.service
$ sudo systemctl start vgpu.service
```
