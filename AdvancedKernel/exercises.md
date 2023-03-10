## Linux Kernel Fundamentals: Chapter 1, Surveying the Linux Kernel

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

-------------------------------------------------

## Linux Kernel Fundamentals: Chapter 2, Booting

You need to get to the system console. Using virt-manager and a VM is a handy way to do this.

1. Run dmesg and look to see if each output line starts with a time stamp in the form of [ 0.1234]. Reboot. From
your system console, interrupt GRUB and add the option apic=debug to the kernel line. Continue with the bootup.
After booting, log in and see if dmesg output now looks different. Is there now more apic output? Using https://wiki.centos.org/HowTos/Grub2, or another appropriate distro, make a custom GRUB entry that is the same as your current kernel’s entry, but with some changes:

a. Make the title say Custom Linux Boot Entry Experiment.
b. Add the kernel command-line option initcall_debug to the end of the kernel line.
c. For your distro, determine the grub.cfg file to use, and then make a new one with grub2-mkconfig.
For example: grub2-mkconfig -o /boot/grub/grub.cfg
d. Reboot, pick your new GRUB entry, and after it boots, look at /proc/cmdline to see if your kernel
command line has initcall_debug.

a) 

    $ dmesg | head -200 > dmesg.save
    $ sudo reboot
    > Type 'e' on boot grub and change the name
b)
    $ view /boot/gruv/grub.cfg
    $ cd /etc/grub.d/
    $ sudo cp /tmp/42_custom .
    $ sudo grub-mkconfig -o /boot/grub/grub.cfg
    $ sudo reboot


2. Interrupt GRUB, and choose your original kernel entry. At the end of the vmlinuz line, add init=/bin/bash and
boot. What happened? Turn the power off and on, interrupt GRUB again, and this time, put rdinit=/bin/sh at the
end and boot. What happens now?
Reset your VM back into your full Linux environment.


3. Is init a link? Does your system have a program called init? Is PID 1 running init?


4. "Rebooting from Custom init"

    $ which init
    /usr/sbin/init

    $ ls -l /usr/sbin/init

    $ ps -ef | grep init
    root           1       0  0 17:57 ?        00:00:02 /sbin/init splash


5. Using pstree, can you determine which processes are direct descendants of PID 1 including the process running
your pstree command?

- systemd
- systemd -> gnome-terminal -> bash -> pstree

------------------------------------------------------------------

## Linux Kernel Fundamentals: Chapter 3, Working with Loadable Kernel Modules

In this series of challenges, we create a loadable module, experiment with the use of loadable modules, and create and
use parameters for modules.
You need to be root.
You need to have installed a Linux kernel development package. On Ubuntu, that is normally linux-headers-$(uname -r). There should be a link to the kernel directory with a Makefile, including subdirectory etc., called /lib/modules/$(uname -r)/build. If the build does not exist or is a broken link, then you don’t have everything you need installed.
We are working with Linux kernel code. Bad things can happen. It is best to do this with a virtual machine that is OK if it becomes corrupted.

1. Create a loadable module. Make an empty directory to work in.

a. Create a file called lab.c. Add preprocessor commands to include theses two header files: linux/module.h and
linux/init.h.

b. Add a function called my_init_module(). This should take no arguments and return an int. This function should use
printk() to print a message. my_init_module() should return 0. Register the function with module_init().

c. Create a function called my_cleanup_module() that takes no arguments and has no return value. It should print a
message with printk(). Register the function with module_exit().

d. Add a line at the end for the module license, MODULE_LICENSE(“GPL”);

e. Create a Makefile for making lab.ko.

f. Compile your module to a .ko file by using make.

g. Load your module with insmod. You need to use sudo.

h. What output did you see? You may need to use the dmesg command.

i. Run lsmod. Do you see your module?

j. Use rmmod to unload your module. What message did you see with dmesg

k. Run lsmod again. Do you still see your module?

2. Experiment with the return code of init_module().

a. Edit your module and change the return value of init_module() from 0 to -1.

b. Compile the module, and try to reload it with insmod. What error did you get?

c. Does your module show up in the output of lsmod?

d. What happens if you try to unload the module with rmmod?

e. Did my_cleanup_module() ever get called?

3. Experiment with embedded documentation.

a. Modify your module to include the module author and module description.

b. Recompile your module. Run modinfo with the -d and -a options against your module.

4. Add some modifiable parameters.

a. Edit your module. Add both a static int called number and a static char* called word. Initialize number to some
integer. Initialize word to some string.

b. Use the module_param() macro to flag number as an integer and word as a string.

c. Edit the module and use the MODULE_PARM_DESC() to give descriptions for both number and word.

d. Recompile your module. Run modinfo -p against the module.

e. Edit the init_module() function. Have it print out the values of number and word with printk().

f. Recompile and load your module. Unload and reload the module while passing new values of number and word as
arguments to insmod.