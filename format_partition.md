#  How to format a usb drive with CLI

First we need to insert the usb drive and identify it on our system:

    $ sudo fdisk -l

    Disk /dev/sdb: 7,5 GiB, 8022654976 bytes, 15669248 sectors
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disklabel type: dos
    Disk identifier: 0x0c7b9850

    Device     Boot   Start     End Sectors  Size Id Type
    /dev/sdb1  *         64 5570559 5570496  2,7G  c W95 FAT32 (LBA)
    /dev/sdb2       5570560 5752895  182336   89M  1 FAT12

Once we have identify it lets umounted before erasing it.

    $ sudo umount /dev/sdb

Now we can proceed to erase all information (partition tables and data)

    $ sudo dd if=/dev/zero of=/dev/sdb status=progess

    2704000000 bytes (2,7 GB, 2,5 GiB) copied, 1044 s, 2,6 MB/s

After we have succesfully rewrote everything with zeros, we can start out by creating a new partition table. We have multiple options to do this task fdisk, parted, gparted...

