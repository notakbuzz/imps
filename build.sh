#!/usr/bin/env bash
#
# Copyright (C) 2020 FreakyOS project.
#
# Licensed under the General Public License.
# This program is free software; you can redistribute it and/or modify
# in the hope that it will be useful, but WITHOUT ANY WARRANTY;
#
#

# Global variables
DEVICE="$1"
SYNC="$2"
CLEAN="$3"
CCACHE="$4"
DATE="$(date)"
PBUILD="$5"
JOBS="$(($(nproc --all)-2))"

# Colors makes things beautiful
export TERM=xterm
red=$(tput setaf 1)             #  red
grn=$(tput setaf 2)             #  green
blu=$(tput setaf 4)             #  blue
cya=$(tput setaf 6)             #  cyan
txtrst=$(tput sgr0)             #  Reset

function exports() {
   export CUSTOM_BUILD_TYPE=OFFICIAL
   export KBUILD_BUILD_HOST="StormPooper"
}

function sync() {
    # It's time to sync!
   git config --global user.name "bunnyyTheFreak"
   git config --global user.email "hsinghalk@yahoo.com"
   echo -e ${blu} "[*] Syncing sources... This will take a while" ${txtrst}
   rm -rf .repo/local_manifests
   repo init --depth=1 -u git://github.com/FreakyOS/manifest.git -b still_alive
   repo sync -c -j"$JOBS" --no-tags --no-clone-bundle --force-sync
   echo -e ${cya} "[*] Syncing sources completed!" ${txtrst}
}

function track_private() {
   echo -e ${blu} "[*] Fetching private repos..." ${txtrst}
   sudo rm -rf packages/apps/WallBucket
   git clone "git@github.com:FreakyOS/WallBucket.git" -b test packages/apps/WallBucket
   echo -e ${cya} "[*] Fetched private repos successfully!" ${txtrst}
}

function use_ccache() {
    # CCACHE UMMM!!! Cooks my builds fast
   if [ "$CCACHE" = "true" ]; then
      export CCACHE_DIR=/var/lib/jenkins/workspace/jenkins-ccache
      ccache -M 50G
      export CCACHE_EXEC=$(which ccache)
      export USE_CCACHE=1
   echo -e ${blu} "[*] Yumm! ccache enabled!" ${txtrst}
   elif [ "$CCACHE" = "false" ]; then
      export CCACHE_DIR=/var/lib/jenkins/workspace/jenkins-ccache
   echo -e ${grn} "[*] Ugh! ccache path exported!" ${txtrst}
   fi
}

function clean_up() {
  # It's Clean Time
   if [ "$CLEAN" = "true" ]; then
   echo -e ${blu} "[*] Running clean job - full" ${txtrst}
      make clean && make clobber
   echo -e ${grn}"[*] Clean job completed!" ${txtrst}
   elif [ "$CLEAN" = "false" ]; then
   echo -e ${blu} "[*] Nothing to clean!" ${txtrst}
    fi
}

function build_main() {
  # It's build time! YASS
   source build/envsetup.sh
   echo -e ${blu} "[*] Starting the build..." ${txtrst}
   brunch ${DEVICE}
}

function build_end() {
  # It's upload time!
   sudo rm -rf out/target/product/"$DEVICE"/ota_config 
   echo -e ${blu} "[*] Uploading the build!" ${txtrst}
   rsync -azP  -e ssh out/target/product/"$DEVICE"/FreakyOS*.zip bunnyy@frs.sourceforge.net:/home/frs/project/freakyos/"$DEVICE"/
#   gdrive upload out/target/product/"$DEVICE"/FreakyOS*.zip   
   echo -e ${blu} "[*] Cloning OTA CONFIG and OTA JSON for pushing the changelog on the gerrit..." ${txtrst}
   echo -e ${blu} "[*] Kindly edit the commit message on the gerrit!" ${txtrst}
   cd out/target/product/"$DEVICE"
   git clone "ssh://bunnyyTheFreak@freakyos.xyz:29418/FreakyOS/ota_config" && scp -p -P 29418 bunnyyTheFreak@freakyos.xyz:hooks/commit-msg "ota_config/.git/hooks/"
   cp -f FreakyOS*-Changelog.txt ota_config/"$DEVICE"/"$DEVICE.txt"
   cp -f FreakyOS*.zip.json ota_config/"$DEVICE"/"$DEVICE.json"
   cd ota_config/
   git add --all; git commit -m "$DEVICE: Push $DATE Build!"
   git commit --amend --signoff -v -n
   git push "ssh://bunnyyTheFreak@freakyos.xyz:29418/FreakyOS/ota_config" "HEAD:refs/for/still_alive"
   echo -e ${blu} "[*] Removing private repos..." ${txtrst}
   sudo rm -rf packages/apps/WallBucket
   echo -e ${blu} "[*] Removed private repos!" ${txtrst}

}

exports
if [ "$SYNC" = "true" ]; then
    sync
    track_private
elif [ "$SYNC" = "false" ]; then
    track_private
fi


use_ccache
clean_up
if [ "$PBUILD" = "true" ]; then
build_main
build_end
elif [ "$PBUILD" = "false" ]; then
build_end
fi
