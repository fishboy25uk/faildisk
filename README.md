# FailDisk

- [Intro](#intro)
- [Requirements](#requirements)
- [Setup Using Pre-Built Image](#setup-prebuilt)
- [Setup Using Script](#setup-script)
- [First boot](#first-boot)
- [roubleshooting](#troubleshooting)
- [Disclaimer](#disclaimer)

## Intro

A normal requirement of digital forensics is that methods used for imaging digital storage are capable of detecting and alerting the technician to the presence of bad sectors (areas of unreadable data) on a storage medium. This presents a challenge for validation as testing of this ability requires a medium which will present errors in a consistent way. Whilst it is possible to use a hard drive which is failing, the way in which it fails cannot be relied upon to be consistent. 

However, by using two functions built into the Linux kernel is possible to build a small low-cost device with USB connection that, when connected to a host imaging system, will present read errors in a configurable and consistent way. This device can therefore be used as a reference to test the behaviour of imaging methods when presented with “bad” sectors.

## Methodology

The method involves setting up a logical storage volume over a backing image file filled with random data by using dmsetup [dmsetup](http://linux.die.net/man/8/dmsetup). A table map is then applied to the volume and, using the "error" option for the tablemap, areas are defined which will return an i/o errors when attempts are made to read them.

Once this is set up the logical volume is then paired with the g_mass_storage module which will make the Pi Zero appear to hosts as a Mass Storage Gadget when connected to them (the Pi acts as a client rather than a host). The logical storage area can then be read as if it was any other Mass Storage device e.g. USB stick but will present errors to the host when those specifically defined error sectors are queried. 

This implementation is made possible by the use of the USB On The Go (OTG) port on the Pi Zero which can act in both client and host mode

## Requirements
 - Raspberry Pi Zero
 - SD card of at least 4GB
 - Standard Micro USB to USB cable
 - Case for Pi Zero (optional)

## Setup Using Pre-Built Image

### Windows

 - Download the latest FailDisk image from the [releases](http://linux.die.net/man/8/dmsetup) section and unzip.
 - Insert the SD card into the host.
 - Using a disk writer such as [Win32Imager](https://sourceforge.net/projects/win32diskimager/), write the image file to the SD card.
 - 
 - Insert the SD card into the Pi and connect the USB cable to the Pi using the "USB" port (The "Power" port does not need to be connected to another USB cable, it will be powered though the one "USB" port)
 - The Pi should start booting (you will see the green flashing LED) and will start generating the backing data file, which should take no more than 30 minutes.
 -

## Setup Using Script

Alternatively, FailDisk can be set up by writing the Raspbian Lite image to the SD card then running the installer script. This gets the FailDisk to the same state as if the pre-built image had just been written.


    mv /boot/config-reinstall.txt /boot/config.txt
    reboot

**Remember to backup all your data and original config.txt before doing this!**

## Reporting bugs and improving the installer
When you encounter issues, have wishes or have code or documentation improvements, we'd like to hear from you! 
We've actually written a document on how to best do this and you can find it [here](CONTRIBUTING.md).

## Disclaimer
We take no responsibility for ANY data loss. You will be reflashing your SD card anyway so it should be very clear to you what you are doing and will lose all your data on the card. Same goes for reinstallation.

See LICENSE for license information.

  [1]: http://www.raspbian.org/ "Raspbian"
