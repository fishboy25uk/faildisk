# FailDisk

- [Introduction](#introduction)
- [Methodology](#methodology)
- [Requirements](#requirements)
- [Setup Using Pre-Built Image](#setup-using-pre-built-image)
- [Setup Using Script](#setup-using-script)
- [First Boot](#first-boot)
- [Customising](#customising)
- [Issues](#issues)
- [License](#license)

## Introduction

A normal requirement of digital forensics is that methods used for imaging digital storage are capable of detecting and alerting the technician to the presence of bad sectors (areas of unreadable data) on a storage medium. This presents a challenge for validation as testing of this ability requires a medium which will present errors in a consistent way. Whilst it is possible to use a hard drive which is failing, the way in which it fails cannot be relied upon to be consistent. 

However, by using two functions built into the Linux kernel is possible to build a small low-cost device with USB connection that, when connected to a host imaging system, will present read errors in a configurable and consistent way. This device can therefore be used as a reference to test the behaviour of imaging methods when presented with “bad” sectors.

## Methodology

The method involves setting up a logical storage volume over a backing image file filled with random data by using [dmsetup](http://linux.die.net/man/8/dmsetup). A table map is then applied to the volume and, using the "error" option for the tablemap, areas are defined which will return an i/o errors when attempts are made to read them.

Once this is set up the logical volume is then paired with the g_mass_storage module which will make the Pi Zero appear to hosts as a Mass Storage Gadget when connected to them (the Pi acts as a client rather than a host). The logical storage area can then be read as if it was any other Mass Storage device e.g. USB stick but will present errors to the host when those specifically defined error sectors are queried. 

This implementation is made possible by the use of the USB On The Go (OTG) port on the Pi Zero which can act in both client and host mode

## Requirements
 - Raspberry Pi Zero
 - SD card of at least 4GB
 - Standard Micro USB to USB cable
 - Case for Pi Zero (optional)

## Setup Using Pre-Built Image

 1. Download the [latest FailDisk image](https://s3-eu-west-1.amazonaws.com/divetoolsio/faildisk/releases/faildisk-latest.zip) and unzip the image.
 
 2. Write the image to the SD card:
    ### Windows
    Using a disk writer such as [Win32Imager](https://sourceforge.net/projects/win32diskimager/), write the image file to the SD card.

    ### Linux
    Use DD to write the image file to the SD card, replacing sdX with the SD card device.

 ```dd if=faildisk-latest.img of=/dev/sdX bs=512```

## Setup Using Script

Alternatively, FailDisk can be set up by writing the Raspbian Lite image to the SD card then running the installer script. This gets the FailDisk to the same state as if the pre-built image had just been written. In addition to the equipment listed above you will also need to be able to connect to the command line interface of the Pi either by connecting a keyboard or connecting to a network via a USB-Ethernet adapter.

 1. Download the [lastest Raspian Lite image](https://downloads.raspberrypi.org/raspbian_lite_latest) from raspberrypi.org and unzip the image.
 2. Write the image to the SD card (see instructions for writing the image in the 'Setup Using Pre-Built Image' section above).
 3. Download the [latest setup script](https://github.com/divetoolsio/faildisk/blob/master/scripts/faildisk-setup.sh) and copy it to the "boot" partition on the SD card, which should be accessible after writing on Windows or Linux.
 4. Power the Pi by connecting a USB cable to the "Power" USB socket and connect with username "pi" and password "raspberry"
 5. First, make the faildisk setup script executable, then run it:

  ```sudo chmod +x /boot/faildisk-setup.sh```
  
  ```sudo ./boot/faildisk-setup.sh```

 6. The script will execute and then prompt when it is ready to reboot.

## First Boot
 1. Insert the SD card into the Pi
 2. Connect the USB cable to the Pi using the "USB" port (The "Power" port does not need to be connected to another USB cable, it will be powered though the one "USB" port)
 3. The Pi should start booting (you will see the green flashing LED) and will start generating the backing data file, which should take no more than 30 minutes (This will only happen once after initial setup).
 4. Once complete the FailDisk device should appear as a mass storage device to the OS. Because there is no file system it will not appear as a mounted disk but it will be present as a physical disk and be ready for use.

## Usage

 1. Insert the USB cable into the "USB" port and the other end into the host. After approximately 20 seconds the FailDisk will show as a connected USB device. Depending on OS the application used it may be described as "FailDisk", "Netchip" or "Linux File-Stor Device"
 2. Image as per a physical disk using the imaging tool of your choice. By default the table mapping file is set up as below:
 
    | Sector Offset | Byte Offset | # Sectors | # Bytes   |
    |---------------|-------------|-----------|-----------|
    | 100000        | 51200000  	 | 1         | 512       |
    | 200000        | 102400000   | 2         | 1024      |
    | 300000        | 153600000   | 4         | 2048      |
    | 400000        | 204800000   | 8         | 4096      |
    | 500000        | 256000000   | 16        | 8192      |
    | 600000        | 307200000   | 32        | 16384     |
    | 700000        | 358400000   | 64        | 32768     |
    | 800000        | 409600000   | 128       | 65536     |
    | 900000        | 460800000   | 256       | 131072    |
    | 1000000       | 512000000	  | 1048576   | 536870912 |
    | 2100000       |	1075200000  | 1048576   | 536870912 |
    | 3300000       | 1689600000  | 256       | 131072    |
    | 3400000       |	1740800000  | 128       | 65536     |
    | 3500000       | 1792000000  | 64        | 32768     |
    | 3600000       | 1843200000  | 32        | 16384     |
    | 3700000       | 1894400000  | 16        | 8192      |
    | 3800000       | 1945600000  | 8         | 4096      |
    | 3900000       | 1996800000  | 4         | 2048      |
    | 4000000       | 2048000000  | 2         | 1024      |
    | 4100000       | 2099200000  | 1         | 512       |

NB: It is belived that, due to the USB Gadget module implementation, the smallest read chuck size the FailDisk is currently capable of is 4K (4096 bytes). Therefore the imaging solution will likely show an error size of 8 sectors (4KB) even in areas where there is only 1,2 or 4 error sectors. Hopefully this can be fixed in the future.

## Customising

Both the table mapping and the data block size can be customised by following the steps below:

### Customising Table Mapping

 1.	Remove the SD card from the FailDisk and connect to a host machine using a card reader and appropriate adaptor where necessary.
 2.	On the FAT32 “boot” partition , navigate to the “faildisk” directory and open the “faildisk_table” file for editing.
 3.	Entries in the table should be added or modified as follows:
    
    For readable data:
	   <<Starting Sector>> <<Sector Size>> linear /dev/loop0 <<Starting Sector>>
	
    For errors:
    <<Starting Sector>> <<Sector Size>> error

    The last entry should make up the remainder of the volume.
    <<Starting Sector>> <<Total Sectors - Starting Sector>> linear /dev/loop0 <<Starting Sector>>
    e.g. the remainder of the total 4194304 sectors which make up the default 2GB data file.
    4100001 94303 liner linear /dev/loop0 4100001

 4.	Save the text file then replace the SD card back in the FailDisk. Changes should take effect on rebooting.

### Customising Data Block Size

NB:	Ensure you have adequate storage space on the SD card for the image file required.

 1.	Follow the "Setup Using Script" guide, steps  1-3.
 2.	Open the downloaded script and find the line:

    ```echo "	sudo dd if=/dev/urandom of=/faildisk/faildisk_block.img bs=512 count=4194304" >> /etc/rc.local```

 3. Change the the number after count to the size of the desired partiton in bytes divided by 512 to get the number of sectors.

 4. Follow the remainder of the sections in the "Setup Using Script" guide. Once complete, power down the FailDisk and edit the table map as per the "Customising Table Mapping" section, taking into account the differing data block size.

## Issues
Please report any issues in the issues section [here](https://github.com/divetoolsio/faildisk/issues).

### License
See LICENSE for license information.
