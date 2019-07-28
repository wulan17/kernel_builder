#!/bin/bash

source /home/vsts/work/1/s/config.sh

# Email for git
ci_repo=$(cat /home/vsts/work/1/s/.git/config | grep url | sed 's|url = https://github.com/||' | sed 's|.git||')
git config --global user.email "$GITHUB_EMAIL"
git config --global user.name "$GITHUB_USER"

mkdir -p ~/bin
wget 'https://storage.googleapis.com/git-repo-downloads/repo' -P ~/bin
chmod +x ~/bin/repo
export PATH=~/bin:$PATH
export USE_CCACHE=1
sudo apt-get update
sudo apt-get install liblz4-dev openjdk-8-jdk android-tools-adb bc bison build-essential curl flex g++-multilib gcc-multilib gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev lib32z1-dev libesd0-dev liblz4-tool libncurses5-dev libsdl1.2-dev libssl-dev libwxgtk3.0-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc yasm zip zlib1g-dev


TELEGRAM_TOKEN=$(cat /tmp/tg_token)
TELEGRAM_CHAT=$(cat /tmp/tg_chat)
GITHUB_TOKEN=$(cat /tmp/gh_token)

export TELEGRAM_TOKEN
export TELEGRAM_CHAT
export GITHUB_TOKEN

out="out"

cd /home/vsts/work/1/s/

echo "Sync started"
/home/vsts/work/1/s/telegram -M "Sync Started"
SYNC_START=$(date +"%s")
bash clone.sh
chmod +x /home/vsts/work/1/s/arm-linux-androideabi-4.9/bin/*
chmod +x /home/vsts/work/1/s/arm-linux-androideabi-4.9/arm-linux-androideabi/bin/*
chmod +x /home/vsts/work/1/s/arm-linux-androideabi-4.9/libexec/gcc/arm-linux-androideabi/4.9.x/*
chmod +x /home/vsts/work/1/s/arm-linux-androideabi-4.9/libexec/gcc/arm-linux-androideabi/4.9.x/plugin
SYNC_END=$(date +"%s")
SYNC_DIFF=$((SYNC_END - SYNC_START))
if [ -e android_kernel_xiaomi_mt6765 ]; then
    echo "Sync completed successfully in $((SYNC_DIFF / 60)) minute(s) and $((SYNC_DIFF % 60)) seconds"
    echo "Build Started"
    /home/vsts/work/1/s/telegram -M "Sync completed successfully in $((SYNC_DIFF / 60)) minute(s) and $((SYNC_DIFF % 60)) seconds"
	/home/vsts/work/1/s/telegram -M "Build Start
Dev : "$KBUILD_BUILD_USER"
Product : Kernel
Device : "$device"
Compiler : "$(${CROSS_COMPILE}gcc --version | head -n 1)"
Date : "$(env TZ="$timezone" date)""

    BUILD_START=$(date +"%s")
	# Set kernel source workspace
	cd $BUILD
	# Make and Clean
	make clean
	make mrproper
	# Make <defconfig>
	make O=$out ARCH=$ARCH $defconfig
	# Build Kernel
	make O=$out ARCH=$ARCH -j4
    BUILD_END=$(date +"%s")
    BUILD_DIFF=$((BUILD_END - BUILD_START))
	cd /home/vsts/work/1/s/AnyKernel
	cp $BUILD/out/arch/$ARCH/boot/zImage .
	zip_name="kernel-"$device"-"$(env TZ="$timezone" date +%Y%m%d)"-"$(env TZ="$timezone" date +%I%M%S)""
	export zip_name
	zip -r $zip_name.zip ./*
    export finalzip_path=$(ls /home/vsts/work/1/s/AnyKernel/"$zip_name".zip | tail -n -1)
    export tag="Kernel"
    if [ -e "$finalzip_path" ]; then
        echo "Build completed successfully in $((BUILD_DIFF / 60)) minute(s) and $((BUILD_DIFF % 60)) seconds"

        echo "Uploading"

        /home/vsts/work/1/s/github-release "$release_repo" "$tag" "master" "Kernel for "$device"

Date: $(env TZ="$timezone" date)" "$finalzip_path"

        echo "Uploaded"

        /home/vsts/work/1/s/telegram -M "Build completed successfully in $((BUILD_DIFF / 60)) minute(s) and $((BUILD_DIFF % 60)) seconds
		
Download: ["$zip_name".zip](https://github.com/"$release_repo"/releases/download/"$tag"/"$zip_name")"

    else
        echo "Build failed in $((BUILD_DIFF / 60)) minute(s) and $((BUILD_DIFF % 60)) seconds"
        /home/vsts/work/1/s/telegram -N -M "Build failed in $((BUILD_DIFF / 60)) minute(s) and $((BUILD_DIFF % 60)) seconds"
        exit 1
    fi
else
    echo "Sync failed in $((SYNC_DIFF / 60)) minute(s) and $((SYNC_DIFF % 60)) seconds"
    /home/vsts/work/1/s/telegram -N -M "Sync failed in $((SYNC_DIFF / 60)) minute(s) and $((SYNC_DIFF % 60)) seconds"
    exit 1
fi
