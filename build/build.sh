#!/bin/bash
# Variables
repo="https://github.com/intel/linux-intel-lts.git"
branch="5.4/yocto"
patchesfolder=""
configurl="https://kernel.ubuntu.com/~kernel-ppa/config/focal/linux/5.4.0-44.48/amd64-config.flavour.generic"
version="-intelgvt"
revision="3.0.0"

# git shallow clone linux kernel at specified branch with single history depth
echo "Performing shallow clone of kernel"
git clone --depth 1 $repo --branch $branch --single-branch kernel


# Apply all patches from folder specified by patchesfolder to git repo at folder named kernel
if [ ! -z "$patchesfolder" ] && [ -d "$patchesfolder" ]; then
    echo "Apply kernel patches"
    git apply --directory=kernel $patchesfolder/*
fi

# Fetch kernel config to .config and apply it using make oldconfig
if [ ! -z "$configurl" ]; then
    echo "fetching kernel config from $configurl"
    /usr/bin/wget -q -O kernel/.config $configurl
fi

echo "Apply kernel config"
( cd kernel && yes '' | make oldconfig )

# Run kernel package building using Ubuntu kernel packaging convention, \
# this will take a long time
echo "Build kernel_image and kernel_headers"
( cd kernel && CONCURRENCY_LEVEL=`nproc` fakeroot make-kpkg --initrd --append-to-version=$version \
        --revision $revision --overlay-dir=/usr/share/kernel-package kernel_image kernel_headers )
