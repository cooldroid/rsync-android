#!/bin/bash
#
# build_android.sh - build rsync binaries for different mobile architectures using the Android NDK
#
# Florian Dejonckheere <florian@floriandejonckheere.be>
#

# Whether or not to strip binaries (smaller filesize)
STRIP=1

API=24
GCC=4.9
NDK="/media/android/android-ndk-r15c"
SYSPREFIX="${NDK}/platforms/android-${API}/arch-"
ARCH=(arm arm64)
PREFIX=(arm-linux-androideabi- aarch64-linux-android-)
CCPREFIX=(arm-linux-androideabi- aarch64-linux-android-)

cd rsync/
for I in $(seq 0 $((${#ARCH[@]} - 1))); do
	make clean
	export CC="${NDK}/toolchains/${PREFIX[$I]}${GCC}/prebuilt/linux-x86_64/bin/${CCPREFIX[$I]}gcc --sysroot=${SYSPREFIX}${ARCH[$I]} -D__ANDROID_API__=$API"
	./configure CFLAGS="-static" --host="${PREFIX[$I]%?}"
	make
	(( $STRIP )) && ${NDK}/toolchains/${PREFIX[$I]}${GCC}/prebuilt/linux-x86_64/bin/${CCPREFIX[$I]}strip rsync
	mv rsync "../rsync-${ARCH[$I]}"
done

echo -en "\e[1;33m"
for I in $(seq 0 $((${#ARCH[@]} - 1))); do
	file "../rsync-${ARCH[$I]}"
done
echo -en "\e[0m"
