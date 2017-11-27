#!/bin/bash
#
# build_android.sh - build rsync binaries for different mobile architectures using the Android NDK
#
# Florian Dejonckheere <florian@floriandejonckheere.be>
#

# Whether or not to strip binaries (smaller filesize)
STRIP=1

API=21
GCC=4.9
NDK="/media/android/android-ndk-r10e"
SYSPREFIX="${NDK}/platforms/android-${API}/arch-"
ARCH=(arm)
PREFIX=(arm-linux-androideabi-)
CCPREFIX=(arm-linux-androideabi-)

cd rsync/
for I in $(seq 0 $((${#ARCH[@]} - 1))); do
	make clean
	export CC="${NDK}/toolchains/${PREFIX[$I]}${GCC}/prebuilt/linux-x86_64/bin/${CCPREFIX[$I]}gcc --sysroot=${SYSPREFIX}${ARCH[$I]}"
	./configure CFLAGS="-static" --host="${ARCH[$I]}"
	make
	(( $STRIP )) && ${NDK}/toolchains/${PREFIX[$I]}${GCC}/prebuilt/linux-x86_64/bin/${CCPREFIX[$I]}strip rsync
	mv rsync "../rsync-${ARCH[$I]}"
done

echo -en "\e[1;33m"
for I in $(seq 0 $((${#ARCH[@]} - 1))); do
	file "../rsync-${ARCH[$I]}"
done
echo -en "\e[0m"
