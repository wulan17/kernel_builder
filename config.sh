#!/bin/bash

GITHUB_USER=wulan17
GITHUB_EMAIL=galihgustip@gmail.com@gmail.com

export oem=xiaomi
export device=cactus

BUILD="/home/vsts/work/1/s/android_kernel_xiaomi_mt6765"
ARCH="arm"
SUBARCH="arm"
defconfig="cactus_defconfig"
export defconfig
# Set kernel source workspace
cd $BUILD
# Export ARCH <arm, arm64, x86, x86_64>
export ARCH
# Export SUBARCH <arm, arm64, x86, x86_64>
export SUBARCH
# Set kernal name
export LOCALVERSION=-wulan17
# Export Username
export KBUILD_BUILD_USER=wulan17
# Export Machine name
export KBUILD_BUILD_HOST=AzureDevOps
# Compiler String
export CROSS_COMPILE=/home/vsts/work/1/s/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-

release_repo="wulan17/kernel_builder"

timezone="Asia/Jakarta"
