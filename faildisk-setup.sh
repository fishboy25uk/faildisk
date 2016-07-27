#!/bin/bash
#FAILDISK SETUP SCRIPT
#20160713 - Initial Release
echo "Setting up FAILDISK"
echo
echo "prepare autoboot script - will run on reboot"
echo "#!/bin/bash" > /etc/rc.local
echo "if [ ! -f /faildisk/faildisk_block.img ]; then" >> /etc/rc.local
echo "	sudo parted -s /dev/mmcblk0 rm 2" >> /etc/rc.local
echo "	sudo parted -s /dev/mmcblk0 unit B mkpart primary 70254592 3534749696" >> /etc/rc.local
echo "	sudo resize2fs /dev/mmcblk0p2" >> /etc/rc.local
echo "	sudo dd if=/dev/urandom of=/faildisk/faildisk_block.img bs=512 count=4194304" >> /etc/rc.local
echo "fi" >> /etc/rc.local
#setup block
echo "losetup /dev/loop0 /faildisk/faildisk_block.img" >> /etc/rc.local
echo "dmsetup create errdev0 /boot/faildisk/faildisk_table" >> /etc/rc.local
#start modprobe
echo "sudo modprobe g_mass_storage file=/dev/mapper/errdev0 stall=0" >> /etc/rc.local
echo "exit 0" >> /etc/rc.local
echo "Setting up dwc2 module"
echo "dtoverlay=dwc2" >> /boot/config.txt
echo "dwc2" > /etc/modules
#These run now
echo "Setting up faildisk directory"
sudo mkdir /faildisk
sudo mkdir /boot/faildisk
echo "Writing faildisk parameters"
echo "" > /boot/faildisk/faildisk_table
echo '0 100000 linear /dev/loop0 0' >> /boot/faildisk/faildisk_table
echo '100000 1 error' >> /boot/faildisk/faildisk_table
echo '100001 99999 linear /dev/loop0 100001' >> /boot/faildisk/faildisk_table
echo '200000 2 error' >> /boot/faildisk/faildisk_table
echo '200002 99998 linear /dev/loop0 200002' >> /boot/faildisk/faildisk_table
echo '300000 4 error' >> /boot/faildisk/faildisk_table
echo '300004 99996 linear /dev/loop0 300004' >> /boot/faildisk/faildisk_table
echo '400000 8 error' >> /boot/faildisk/faildisk_table
echo '400008 99992 linear /dev/loop0 400008' >> /boot/faildisk/faildisk_table
echo '500000 16 error' >> /boot/faildisk/faildisk_table
echo '500016 99984 linear /dev/loop0 500016' >> /boot/faildisk/faildisk_table
echo '600000 32 error' >> /boot/faildisk/faildisk_table
echo '600032 99968 linear /dev/loop0 600032' >> /boot/faildisk/faildisk_table
echo '700000 64 error' >> /boot/faildisk/faildisk_table
echo '700064 99936 linear /dev/loop0 700064' >> /boot/faildisk/faildisk_table
echo '800000 128 error' >> /boot/faildisk/faildisk_table
echo '800128 99872 linear /dev/loop0 800128' >> /boot/faildisk/faildisk_table
echo '900000 256 error' >> /boot/faildisk/faildisk_table
echo '900256 99744 linear /dev/loop0 900256' >> /boot/faildisk/faildisk_table
echo '1000000 1048576 error' >> /boot/faildisk/faildisk_table
echo '2048576 51424 linear /dev/loop0 2048576' >> /boot/faildisk/faildisk_table
echo '2100000 1048576 error' >> /boot/faildisk/faildisk_table
echo '3148576 151424 linear /dev/loop0 3148576' >> /boot/faildisk/faildisk_table
echo '3300000 256 error' >> /boot/faildisk/faildisk_table
echo '3300256 99744 linear /dev/loop0 3300256' >> /boot/faildisk/faildisk_table
echo '3400000 128 error' >> /boot/faildisk/faildisk_table
echo '3400128 99872 linear /dev/loop0 3400128' >> /boot/faildisk/faildisk_table
echo '3500000 64 error' >> /boot/faildisk/faildisk_table
echo '3500064 99936 linear /dev/loop0 3500064' >> /boot/faildisk/faildisk_table
echo '3600000 32 error' >> /boot/faildisk/faildisk_table
echo '3600032 99968 linear /dev/loop0 3600032' >> /boot/faildisk/faildisk_table
echo '3700000 16 error' >> /boot/faildisk/faildisk_table
echo '3700016 99984 linear /dev/loop0 3700016' >> /boot/faildisk/faildisk_table
echo '3800000 8 error' >> /boot/faildisk/faildisk_table
echo '3800008 99992 linear /dev/loop0 3800008' >> /boot/faildisk/faildisk_table
echo '3900000 4 error' >> /boot/faildisk/faildisk_table
echo '3900004 99996 linear /dev/loop0 3900004' >> /boot/faildisk/faildisk_table
echo '4000000 2 error' >> /boot/faildisk/faildisk_table
echo '4000002 99998 linear /dev/loop0 4000002' >> /boot/faildisk/faildisk_table
echo '4100000 1 error' >> /boot/faildisk/faildisk_table
echo '4100001 94303 linear /dev/loop0 4100001' >> /boot/faildisk/faildisk_table
echo
echo "Faildisk complete"