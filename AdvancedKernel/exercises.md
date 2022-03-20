Linux Kernel Fundamentals: Chapter 1, Surveying the Linux Kernel

1. What kernel version is your Linux system running?

    antonio@antonio-XPS:~$ uname -r
    5.14.0-1027-oem

------------------------------------------------


2. What is the size of the kernel file that corresponds to the kernel your system is
running?

    antonio@antonio-XPS:~$ ls -la /boot/vmlinuz-5.14.0-1027-oem 
    -rw------- 1 root root 8910016 mar  7 15:38 /boot/vmlinuz-5.14.0-1027-oem

------------------------------------------------

3. How much RAM is available to your running kernel? Note: It may or may not be
the amount of physical RAM on your system.

    antonio@antonio-XPS:~$ cat /proc/meminfo 
    MemTotal:       16114088 kB
    MemFree:         4122608 kB
    MemAvailable:   10419616 kB

    antonio@antonio-XPS:~$ free
                total       usado       libre  compartido búfer/caché  disponible
    Memoria:    16114088     4434216     3714132      732936     7965740    10621300
    Swap:       2097148           0     2097148

------------------------------------------------

4. The command strace will display the system calls that a process makes as it runs.
Using the man command, determine what option for strace will show a summary,
with a count, of the number of times a process called each system call. Using that
option, what system call is called the most by the command date?

    antonio@antonio-XPS:~$ strace -c date
    dom 20 mar 2022 17:46:15 CET
    % time     seconds  usecs/call     calls    errors syscall
    ------ ----------- ----------- --------- --------- ----------------
    28,77    0,000185          23         8           mmap
    23,02    0,000148          24         6           pread64
    10,11    0,000065          21         3           mprotect
    7,15    0,000046          46         1           munmap
    6,84    0,000044           7         6           close
    5,91    0,000038           9         4           openat
    5,60    0,000036           6         6           fstat
    4,04    0,000026           8         3           brk
    3,11    0,000020           6         3           read
    2,18    0,000014          14         1           write
    2,02    0,000013           6         2         1 arch_prctl
    1,24    0,000008           8         1           lseek
    0,00    0,000000           0         1         1 access
    0,00    0,000000           0         1           execve
    ------ ----------- ----------- --------- --------- ----------------
    100.00    0,000643                    46         2 total

------------------------------------------------

5. Can you determine, using strace, what system call is used to change the directory?

We need to create a bash script that performs a cd command. That way, it is possible to strace it.

------------------------------------------------

6. By looking at include/uapi/asm-generic/unistd.h determine about how many system calls are defined in your kernel source.

    antonio@antonio-XPS:/usr/src/linux-oem-5.14-headers-5.14.0-1027/include/uapi/asm-generic$ grep "define __NR" unistd.h | wc -l
    352

------------------------------------------------

7. Run a sleep 100 with & (to put it in the background). What files does its process have open?

    antonio@antonio-XPS:/proc/48156/fd$ ls -la
    total 0
    dr-x------ 2 antonio antonio  0 mar 20 18:03 .
    dr-xr-xr-x 9 antonio antonio  0 mar 20 18:03 ..
    lrwx------ 1 antonio antonio 64 mar 20 18:03 0 -> /dev/pts/1
    lrwx------ 1 antonio antonio 64 mar 20 18:03 1 -> /dev/pts/1
    lrwx------ 1 antonio antonio 64 mar 20 18:03 2 -> /dev/pts/1

------------------------------------------------

8. Does your system have a PCI Ethernet device?

    antonio@antonio-XPS:~$ lspci | grep -i ethernet

------------------------------------------------

9. Is the kernel variable ip_forward (under /proc/sys/…) set to 1 or 0 on your system?

    antonio@antonio-XPS:~$ cd /proc/sys
    antonio@antonio-XPS:/proc/sys$ find . | grep ip_forward
    ./net/ipv4/ip_forward
    ./net/ipv4/ip_forward_update_priority
    ./net/ipv4/ip_forward_use_pmtu
    antonio@antonio-XPS:/proc/sys$ cd net/ipv4/
    antonio@antonio-XPS:/proc/sys/net/ipv4$ cat ip_forward
    1

    antonio@antonio-XPS:~$ sysctl net.ipv4.ip_forward
    net.ipv4.ip_forward = 1

------------------------------------------------

10. According to /sys/block, do you have a block device (disk) sda? If so, do you have device files for partitions of sda? How many? Using strace, does the command fdisk -l (run it as root), open any files under /sys/dev/block?

    antonio@antonio-XPS:/sys/block$ ls -l /dev/sda*
    brw-rw---- 1 root disk 8, 0 mar 20 16:55 /dev/sda

    root@antonio-XPS:/sys/block# strace fdisk -l |& grep sys/dev/block | grep open | wc -l
    269

------------------------------------------------

11. Using dmesg and grep, do you see the kernel reporting the kernel command line?
If not, can you determine if the boot messages from the kernel were lost? Does your system have a log file that recorded the boot messages? You can grep for BOOT_IMAGE under /var/log to look.

    root@antonio-XPS:/sys/block# dmesg | grep -i command
    [    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-5.14.0-1027-oem root=UUID=f162cd75-4251-4ba5-aba0-8f91e6081fa4 ro quiet splash vt.handoff=7

    root@antonio-XPS:/var/log# grep -rl BOOT_IMAGE

------------------------------------------------

12. What other device files are character devices and share the same major number with /dev/null?

    root@antonio-XPS:/dev# ls -l null | grep "^c" | grep " 1,"
    crw-rw-rw- 1 root root 1, 3 mar 20 08:29 null
