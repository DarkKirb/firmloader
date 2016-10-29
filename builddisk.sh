#!/usr/bin/env bash
rm -rf x86/*.bin
gmake -C x86
dd if=/dev/zero of=mtgos.img bs=1M count=2K
dev=$(sudo mdconfig -a -t vnode -f mtgos.img)
sudo gpart create -s mbr $dev
sudo gpart bootcode -b x86/stage1.bin $dev
sudo gpart add -t fat16 $dev
sudo newfs_msdos -F 16 /dev/${dev}s1
dd if=/dev/zero count=4 >> x86/stage2.bin
sudo dd if=x86/stage2.bin oseek=1 of=/dev/$dev
mkdir mount
sudo mount_msdosfs /dev/${dev}s1 mount
mkdir mount/boot
echo "Hey!" > mount/BOOTMSG.TXT
sudo umount mount
sudo mdconfig -d -u $dev
