#!/usr/bin/env bash
rm -rf x86/*.bin
gmake -C x86
sudo gpart delete -i 4 $1
sudo gpart delete -i 3 $1
sudo gpart delete -i 2 $1
sudo gpart delete -i 1 $1
sudo gpart destroy $1
sudo gpart create -s mbr $1
sudo gpart bootcode -b x86/stage1.bin $1
sudo gpart add -t fat16 $1
sudo newfs_msdos -F 16 /dev/${1}s1
sudo dd if=x86/stage2.bin of=/dev/$1 oseek=1
mkdir mount
sudo mount_msdosfs /dev/${1}s1 mount
mkdir mount/boot
sudo umount mount
sync
