Linux Kernel Fundamentals: Chapter 1, Surveying the Linux Kernel

1. What kernel version is your Linux system running?

    antonio@antonio-XPS:~$ uname -r
    5.14.0-1027-oem


2. What is the size of the kernel file that corresponds to the kernel your system is
running?

    antonio@antonio-XPS:~$ ls -la /boot/vmlinuz-5.14.0-1027-oem 
    -rw------- 1 root root 8910016 mar  7 15:38 /boot/vmlinuz-5.14.0-1027-oem

3. How much RAM is available to your running kernel? Note: It may or may not be
the amount of physical RAM on your system.

    antonio@antonio-XPS:~$ cat /proc/meminfo 
    MemTotal:       16114088 kB
    MemFree:         4122608 kB
    MemAvailable:   10419616 kB


4. The command strace will display the system calls that a process makes as it runs.
Using the man command, determine what option for strace will show a summary,
with a count, of the number of times a process called each system call. Using that
option, what system call is called the most by the command date?

5. Can you determine, using strace, what system call is used to change the
directory?

6. By looking at include/uapi/asm-generic/unistd.h determine about how many
system calls are defined in your kernel source.

7. Run a sleep 100 with & (to put it in the background). What files does its process
have open?

8. Does your system have a PCI Ethernet device?

9. Is the kernel variable ip_forward (under /proc/sys/…) set to 1 or 0 on your
system?

10. According to /sys/block, do you have a block device (disk) sda? If so, do you
have device files for partitions of sda? How many? Using strace, does the
command fdisk -l (run it as root), open any files under /sys/dev/block?

11. Using dmesg and grep, do you see the kernel reporting the kernel command line?
If not, can you determine if the boot messages from the kernel were lost? Does
your system have a log file that recorded the boot messages? You can grep for
BOOT_IMAGE under /var/log to look.

12. What other device files are character devices and share the same major number
with /dev/null?