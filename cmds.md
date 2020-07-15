Adb cmd
```bash
adb shell dmesg > dmesg.log
adb logcat -d > logcat.txt
```
#Required Packages
```bash
sudo apt-get update && sudo apt-get install bc git-core gnupg flex bison gperf libsdl1.2-dev libesd0-dev libwxgtk3.0-dev squashfs-tools build-essential zip curl libncurses5-dev zlib1g-dev openjdk-8-jre openjdk-8-jdk pngcrush schedtool libxml2 libxml2-utils xsltproc lzop libc6-dev schedtool g++-multilib lib32z1-dev lib32ncurses5-dev lib32readline6-dev gcc-multilib maven tmux screen w3m ncftp adb fastboot repo python default-jdk
```
#grep & sed
```basg
grep -rl 'a' | xargs sed -i 's/a/c/g'
```
#find
```bash
find . -name "a"
```
#disk usage
```bash
du -sh *
df -h
```
