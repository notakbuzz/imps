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
CCACHE="$3"
CLEAN="$4"
BUILD="$5"
DATE="$(date)"
JOBS="$(($(nproc --all)))"

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
   echo -e ${blu} "\n[*] Syncing sources... This will take a while [*]" ${txtrst}
   rm -rf -v .repo/local_manifests
   repo init --depth=1 -u git://github.com/FreakyOS/manifest.git -b still_alive
   repo sync -c -j"$JOBS" --no-tags --no-clone-bundle --force-sync
   echo -e ${grn} "\n[*] Syncing sources completed! [*]" ${txtrst}
}

function track_private() {
   echo -e ${blu} "\n\n[*] Fetching private repos... [*]" ${txtrst}
   sudo rm -rf -v packages/apps/WallBucket
   git clone "git@github.com:FreakyOS/WallBucket.git" -b test packages/apps/WallBucket
   echo -e ${grn} "\n[*] Fetched private repos successfully! [*]" ${txtrst}
}

function use_ccache() {
    # CCACHE UMMM!!! Cooks my builds fast
if [ "$CCACHE" = "true" ]; then
      echo -e ${blu} "\n\n[*] Enabling cache... [*]" ${txtrst}
      export CCACHE_DIR=/var/lib/jenkins/workspace/jenkins-ccache
      ccache -M 50G
      export CCACHE_EXEC=$(which ccache)
      export USE_CCACHE=1
      echo -e ${grn} "\n[*] Yumm! ccache enabled! [*]" ${txtrst}
elif [ "$CCACHE" = "false" ]; then
      export CCACHE_DIR=/var/lib/jenkins/workspace/jenkins-ccache
      echo -e ${cya} "\n\n[*] Ugh! ccache path exported! [*]" ${txtrst}
fi
}

function clean_up() {
  # It's Clean Time
if [ "$CLEAN" = "true" ]; then
   echo -e ${blu} "\n\n[*] Running clean job - full [*]" ${txtrst}
   make clean && make clobber
   echo -e ${grn}"\n[*] Clean job completed! [*]" ${txtrst}
elif [ "$CLEAN" = "false" ]; then
   echo -e ${red} "\n\n[*] Cleaning existing builds to avoid Push conflicts! [*]" ${txtrst}
   cd out/target/product/"$DEVICE"
   rm -rf -v FreakyOS*.zip FreakyOS*-Changelog.txt FreakyOS*.zip.json
fi
}

function build_main() {
  # It's build time! YASS
   source build/envsetup.sh
   echo -e ${cya} "\n\n[*] Starting the build... [*]" ${txtrst}
   brunch ${DEVICE}
}

function build_end() {
  # It's upload time!
   echo -e ${red} "\n\n[*] Removing existing cloned ota config directory if any! [*]" ${txtrst}
   sudo rm -rf -v out/target/product/"$DEVICE"/ota_config 
   echo -e ${grn} "\n[*] Uploading the build! [*]" ${txtrst}
   rsync -azP -v -e ssh out/target/product/"$DEVICE"/FreakyOS*.zip bunnyy@frs.sourceforge.net:/home/frs/project/freakyos/"$DEVICE"/
#   gdrive upload out/target/product/"$DEVICE"/FreakyOS*.zip   
   echo -e ${blu} "\n[*] Cloning OTA CONFIG for pushing the new json and changelog to gerrit... [*]" ${txtrst}
   echo -e ${red} "\n[*NOTE*] Kindly edit the commit message and remove the blank spaces from the changelog on the gerrit! [*NOTE*]" ${txtrst}
   cd out/target/product/"$DEVICE"
   git clone "ssh://bunnyyTheFreak@freakyos.xyz:29418/FreakyOS/ota_config" && scp -p -P 29418 bunnyyTheFreak@freakyos.xyz:hooks/commit-msg "ota_config/.git/hooks/"
   cp -v -f FreakyOS*-Changelog.txt ota_config/"$DEVICE"/"$DEVICE.txt"
   cp -v -f FreakyOS*.zip.json ota_config/"$DEVICE"/"$DEVICE.json"
   cd ota_config/
   echo -e ${grn} "\n[*] Copying Changelog & Json done! [*]" ${txtrst}
   echo -e ${cya} "\n\n[*] Adding the changed files and committing to gerrit! [*]" ${txtrst}
   git add -v --all
   git commit -v -m "$DEVICE: Push $DATE Build!"
   git commit --amend --signoff -v -n --dry-run
   git push "ssh://bunnyyTheFreak@freakyos.xyz:29418/FreakyOS/ota_config" "HEAD:refs/for/still_alive"
   echo -e ${grn} "\n[*] Commit Pushed! [*]" ${txtrst}
   echo -e ${red} "\n\n[*] Removing private repos... [*]" ${txtrst}
   sudo rm -rf -v packages/apps/WallBucket
   echo -e ${cya} "\n[*] Removed private repos! [*]" ${txtrst}
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

if [ "$BUILD" = "true" ]; then
build_main
build_end
elif [ "$BUILD" = "false" ]; then
build_end
fi
