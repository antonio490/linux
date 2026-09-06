
# Kernel Compilation from Source

This guide explains how to:

1. Inspect and clean up old Linux kernels.
2. Download the Linux kernel source code.
3. Configure the kernel.
4. Compile the kernel and its modules.
5. Install the kernel.
6. Generate the required initramfs.
7. Update GRUB and boot into the new kernel.

> **Warning:** Compiling and installing a kernel manually can make your system unbootable if something goes wrong. Always keep at least one known-working kernel installed so that you can boot it from **GRUB → Advanced options for Ubuntu**.

---

## 1. Check the Currently Running Kernel

Before removing or changing anything, check which kernel is currently running:

```bash
uname -r
```

Example:

```text
6.8.0-57-generic
```

**Do not remove the kernel that is currently running.**

It is also useful to see the kernel architecture:

```bash
uname -m
```

For example:

```text
x86_64
```

---

# Remove Old Kernel Files

## 2. List Installed Kernel Packages

On Debian/Ubuntu systems, you can list installed kernel packages with:

```bash
dpkg --list | grep linux-image
```

Example:

```text
ii  linux-image-6.8.0-57-generic
rc  linux-image-5.11.0-25-generic
rc  linux-image-5.11.0-27-generic
rc  linux-image-5.11.0-34-generic
```

The first column is important:

| Status | Meaning                                             |
| ------ | --------------------------------------------------- |
| `ii`   | Package is installed                                |
| `rc`   | Package was removed, but configuration files remain |
| `un`   | Package is not installed                            |

Therefore, an entry such as:

```text
rc  linux-image-5.11.0-25-generic
```

does **not** mean that the kernel is still installed. The kernel package has already been removed; only residual configuration files remain.

To see all installed kernel images more clearly:

```bash
dpkg -l 'linux-image*' | grep '^ii'
```

You can also check which kernels are available in `/boot`:

```bash
ls -lh /boot
```

---

## 3. Remove Unused Kernels

On Ubuntu/Debian, `apt autoremove` can usually remove packages that are no longer required:

```bash
sudo apt autoremove --purge
```

Review the packages that APT proposes to remove **before confirming**.

> **Important:** Never remove all kernels. Keep at least one known-working kernel available as a fallback.

If you manually installed a kernel, APT may not manage it in the same way as a distribution-provided kernel.

---

## 4. Update GRUB

After removing kernels, regenerate the GRUB configuration:

```bash
sudo update-grub
```

You can inspect the resulting GRUB entries with:

```bash
grep "menuentry " /boot/grub/grub.cfg
```

---

# Compile a New Kernel

## 5. Install Build Dependencies

Before compiling the kernel, install the tools required to build it.

On Ubuntu/Debian:

```bash
sudo apt update
sudo apt install build-essential libncurses-dev bison flex libssl-dev libelf-dev \
    bc dwarves fakeroot cpio rsync
```

If you want to create Debian packages instead of installing directly into the system, `make-kpkg` is generally no longer the preferred approach; the kernel build system can create `.deb` packages directly.

---

## 6. Download the Kernel Source

Choose the kernel version you want to build.

For example:

```bash
KERNEL_VERSION=6.6.50
```

Download the corresponding source archive from the official Linux kernel source repository:

```bash
wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${KERNEL_VERSION}.tar.xz
```

> Replace `6.6.50` with the kernel version you actually want to compile.

Extract the archive:

```bash
tar -xf linux-${KERNEL_VERSION}.tar.xz
```

Enter the source directory:

```bash
cd linux-${KERNEL_VERSION}
```

---

# Configure the Kernel

Before compiling, the kernel must be configured. The configuration determines which drivers, filesystems, networking features, security mechanisms, and other components are built into the kernel or available as modules.

## 7. Start with the Current Kernel Configuration

A convenient starting point is the configuration of the currently running distribution kernel:

```bash
cp /boot/config-$(uname -r) .config
```

This gives you a configuration that is much more likely to work with your existing hardware and software than starting from an empty configuration.

However, the configuration may contain options that are no longer present or have changed in the new kernel version.

Run:

```bash
make oldconfig
```

`oldconfig` asks questions about new configuration options that did not exist in the previous kernel.

If you want the default answer for new options, you can instead use:

```bash
make olddefconfig
```

---

## 8. Configure the Kernel with `menuconfig`

For interactive configuration:

```bash
make menuconfig
```

This opens a terminal-based configuration interface.

From here you can enable or disable:

* CPU features
* Hardware drivers
* Filesystems
* Networking
* Virtualization
* Security features
* Kernel debugging
* Power management
* Device drivers
* Modules

### Built-in vs. Module

Many kernel options provide three choices:

```text
< > Disabled
<M> Module
[*] Built-in
```

In general:

* **Disabled** — the feature is not compiled.
* **Module (`M`)** — compiled as a loadable kernel module.
* **Built-in (`*`)** — compiled directly into the kernel.

For hardware or functionality that is needed very early during boot, a built-in driver may be required, although initramfs can load many drivers as modules.

> **Tip:** If you are unsure about an option, keep the configuration inherited from your distribution kernel rather than disabling it.

---

# Compile the Kernel

## 9. Determine the Number of CPU Cores

You can determine the number of available processors with:

```bash
nproc
```

For example:

```text
8
```

---

## 10. Compile the Kernel

Build the kernel using all available CPU cores:

```bash
make -j"$(nproc)"
```

Depending on your hardware and the kernel configuration, compilation can take anywhere from a few minutes to considerably longer.

If you want to leave some CPU capacity available for other tasks, you can use fewer jobs:

```bash
make -j6
```

---

# Install the Kernel

## 11. Install Kernel Modules

Install the compiled modules:

```bash
sudo make modules_install
```

This normally installs them under:

```text
/lib/modules/<kernel-version>/
```

You can verify the result with:

```bash
ls /lib/modules/
```

---

## 12. Install the Kernel

The traditional direct installation method is:

```bash
sudo make install
```

This normally installs the kernel and related files under `/boot`.

After installation, check:

```bash
ls -lh /boot
```

You should see files corresponding to the new kernel, such as:

```text
vmlinuz-<kernel-version>
System.map-<kernel-version>
config-<kernel-version>
```

### Recommended Alternative: Build Debian Packages

On Debian/Ubuntu, another approach is to build `.deb` packages instead of installing directly into the system:

```bash
make -j"$(nproc)" bindeb-pkg
```

The resulting packages are placed in the parent directory.

You can then install them with:

```bash
cd ..
sudo dpkg -i linux-*.deb
```

This approach has the advantage of letting the Debian package manager track the kernel installation more cleanly.

---

# Initramfs

## 13. Generate the Initial RAM Filesystem

The **initramfs** (initial RAM filesystem) contains files and kernel modules needed during the early stages of boot.

On Debian/Ubuntu, you can generate it with:

```bash
sudo update-initramfs -c -k <kernel-version>
```

For example:

```bash
sudo update-initramfs -c -k 6.6.50
```

You can check the generated file:

```bash
ls -lh /boot/initrd.img-<kernel-version>
```

> Depending on the distribution and installation method, `make install` or the Debian package installation process may already create the initramfs. If an initramfs was created automatically, you do not need to create a second one manually.

You can update initramfs files for all installed kernels with:

```bash
sudo update-initramfs -u -k all
```

---

# Update GRUB

## 14. Regenerate the GRUB Configuration

After installing the kernel and initramfs:

```bash
sudo update-grub
```

GRUB should detect the new kernel automatically.

You can verify that the new kernel appears in the generated configuration:

```bash
grep "<kernel-version>" /boot/grub/grub.cfg
```

---

# Boot the New Kernel

## 15. Reboot

Once everything has been installed successfully:

```bash
sudo reboot
```

During startup, open the GRUB menu.

Select:

```text
Advanced options for Ubuntu
```

You should see the newly compiled kernel listed there.

Select it and boot the system.

---

## 16. Verify the Running Kernel

Once the system has booted, verify that the new kernel is actually running:

```bash
uname -r
```

It should report the version you compiled:

```text
6.6.50
```

You can also inspect the kernel command line:

```bash
cat /proc/cmdline
```

And check for kernel errors:

```bash
dmesg --level=err,warn
```

---

# Troubleshooting

## Kernel Does Not Appear in GRUB

Run:

```bash
sudo update-grub
```

Then check `/boot`:

```bash
ls -lh /boot
```

Also check whether the corresponding modules exist:

```bash
ls /lib/modules/
```

---

## System Fails to Boot

Do **not** panic or immediately remove the new kernel.

From GRUB, select:

```text
Advanced options for Ubuntu
```

and boot an older, known-working kernel.

Once the system is running again, investigate the problem using:

```bash
dmesg
```

and:

```bash
journalctl -b
```

You can also compare the configuration of the new kernel with the working kernel.

---

# Useful Kernel Build Commands

### Start from the current kernel configuration

```bash
cp /boot/config-$(uname -r) .config
make olddefconfig
```

### Interactive configuration

```bash
make menuconfig
```

### Build

```bash
make -j"$(nproc)"
```

### Build only modules

```bash
make modules
```

### Install modules

```bash
sudo make modules_install
```

### Install kernel

```bash
sudo make install
```

### Generate initramfs

```bash
sudo update-initramfs -c -k <kernel-version>
```

### Update GRUB

```bash
sudo update-grub
```

### Check running kernel

```bash
uname -r
```

---

# Complete Example

A simplified workflow looks like this:

```bash
# Check current kernel
uname -r

# Install dependencies
sudo apt update
sudo apt install build-essential libncurses-dev bison flex libssl-dev \
    libelf-dev bc dwarves fakeroot cpio rsync

# Download source
KERNEL_VERSION=6.6.50
wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${KERNEL_VERSION}.tar.xz

# Extract
tar -xf linux-${KERNEL_VERSION}.tar.xz
cd linux-${KERNEL_VERSION}

# Copy current configuration
cp /boot/config-$(uname -r) .config

# Update configuration for the new kernel
make olddefconfig

# Optionally customize the configuration
make menuconfig

# Compile
make -j"$(nproc)"

# Install modules
sudo make modules_install

# Install kernel
sudo make install

# Generate initramfs if it was not generated automatically
sudo update-initramfs -c -k "${KERNEL_VERSION}"

# Update GRUB
sudo update-grub

# Reboot
sudo reboot
```

After reboot:

```bash
uname -r
```

The output should correspond to the kernel version you compiled.

---

## Important Notes

* **Keep a known-working kernel installed** until you have successfully tested the new one.
* Never remove the kernel you are currently running.
* `rc` in `dpkg --list` means the package has been removed but residual configuration remains; it does **not** mean the kernel is installed.
* A distribution kernel configuration is usually a better starting point than creating `.config` from scratch.
* `make olddefconfig` is useful when you want sensible defaults for new configuration options without answering every question interactively.
* `make menuconfig` should be used when you actually need to customize the kernel.
* For production systems, consider building Debian packages (`bindeb-pkg`) rather than installing directly with `make install`.
* Always test the new kernel before removing the old one.


# ARM64 Linux Kernel + BusyBox + Initramfs QEMU Lab

This document summarizes the setup for experimenting with **cross-compiled ARM64 Linux kernels** using **QEMU's `virt` machine**, with **BusyBox** as the userspace and an **initramfs** as the root filesystem.

The goal is to be able to:

* Cross-compile Linux kernels on an x86-64 Ubuntu machine.
* Target ARM64 (`aarch64`).
* Boot kernels safely using QEMU.
* Experiment with different kernel configurations.
* Build a minimal userspace with BusyBox.
* Create an initramfs.
* Boot directly into a BusyBox shell.

---

## 1. Install the required tools

On the Ubuntu build machine:

```bash
sudo apt update

sudo apt install -y \
    git \
    build-essential \
    bc \
    bison \
    flex \
    libssl-dev \
    libelf-dev \
    libncurses-dev \
    dwarves \
    cpio \
    rsync \
    wget \
    xz-utils \
    qemu-system-arm \
    qemu-utils \
    gcc-aarch64-linux-gnu \
    binutils-aarch64-linux-gnu \
    libvirt-daemon-system \
    virt-manager \
    virt-viewer
```

Verify the cross compiler:

```bash
aarch64-linux-gnu-gcc --version
```

Verify QEMU:

```bash
qemu-system-aarch64 --version
```

---

# 2. Create the kernel laboratory directory

We created a dedicated directory to keep source code, configurations, build output, root filesystems and images separate:

```bash
mkdir -p ~/kernel-lab/{src,configs,builds,rootfs,images}
```

The resulting structure is:

```text
~/kernel-lab/
├── src/
│   ├── linux/
│   └── busybox/
│
├── configs/
│
├── builds/
│
├── rootfs/
│
└── images/
```

---

# 3. Get the Linux kernel source

Clone the Linux kernel:

```bash
cd ~/kernel-lab/src

wget https://www.kernel.org/pub/linux/kernel/v6.x/linux-6.18.49.tar.xz
```

Enter the source directory:

```bash
cd ~/kernel-lab/src/linux
```

---

# 4. Target ARM64

Our target is **generic ARM64**, not the physical Raspberry Pi.

The target architecture is:

```text
x86-64 Ubuntu
      │
      │ cross compilation
      ▼
   ARM64
      │
      ▼
 QEMU virt machine
```

This is intentionally different from building specifically for a Raspberry Pi 3.

We use:

```bash
ARCH=arm64
```

and:

```bash
CROSS_COMPILE=aarch64-linux-gnu-
```

---

# 5. Create an out-of-tree kernel build

We keep the source tree clean by putting build output in a separate directory.

```bash
mkdir -p ~/kernel-lab/builds/first
```

Create the default ARM64 configuration:

```bash
make -C ~/kernel-lab/src/linux \
    O=~/kernel-lab/builds/first \
    ARCH=arm64 \
    CROSS_COMPILE=aarch64-linux-gnu- \
    defconfig
```

The configuration is now:

```text
~/kernel-lab/builds/first/.config
```

---

# 6. Configure the kernel

Open the kernel configuration interface:

```bash
make -C ~/kernel-lab/src/linux \
    O=~/kernel-lab/builds/first \
    ARCH=arm64 \
    CROSS_COMPILE=aarch64-linux-gnu- \
    menuconfig
```

For the first kernel, it is better to start with `defconfig` and make sure everything works before aggressively removing features.

Later, we can create configurations such as:

```text
virt-working.config
virt-minimal.config
virt-debug.config
```

---

# 7. Build the Linux kernel

Compile the kernel:

```bash
make -C ~/kernel-lab/src/linux \
    O=~/kernel-lab/builds/first \
    ARCH=arm64 \
    CROSS_COMPILE=aarch64-linux-gnu- \
    -j"$(nproc)"
```

The resulting ARM64 kernel is:

```text
~/kernel-lab/builds/first/arch/arm64/boot/Image
```

Check it:

```bash
file ~/kernel-lab/builds/first/arch/arm64/boot/Image
```

It should identify the file as an ARM64/AArch64 Linux kernel image.

---

# 8. Build BusyBox

BusyBox provides the userspace programs that run **on top of the Linux kernel**.

Important distinction:

```text
Linux kernel
    │
    └── provides CPU, memory, processes, drivers,
        filesystems, networking, etc.

BusyBox
    │
    └── provides userspace programs such as:
        sh
        ls
        mount
        cat
        echo
        etc.
```

BusyBox is **not the kernel**.

Clone BusyBox:

```bash
cd ~/kernel-lab/src

git clone https://git.busybox.net/busybox
```

Enter the source directory:

```bash
cd ~/kernel-lab/src/busybox
```

---

# 9. Configure BusyBox

Start with the default configuration:

```bash
make ARCH=arm64 \
    CROSS_COMPILE=aarch64-linux-gnu- \
    defconfig
```

Open BusyBox configuration:

```bash
make ARCH=arm64 \
    CROSS_COMPILE=aarch64-linux-gnu- \
    menuconfig
```

For our minimal QEMU system, unnecessary utilities can be disabled.

For example, we disabled:

```text
Networking Utilities
    [ ] tc
```

This was necessary because the BusyBox `tc` implementation in the version being built was incompatible with the host kernel headers and produced errors such as:

```text
TCA_CBQ_MAX undeclared
TCA_CBQ_RATE undeclared
struct tc_cbq_lssopt
```

We don't need `tc` for this basic kernel lab.

---

# 10. Build BusyBox

Build it using the ARM64 cross compiler:

```bash
make -j"$(nproc)" \
    ARCH=arm64 \
    CROSS_COMPILE=aarch64-linux-gnu-
```

The build produced:

```text
busybox_unstripped
```

and completed successfully with:

```text
Final link with: m resolv
```

The `fchown()` message seen during compilation was only a warning:

```text
warning: ignoring return value of ‘fchown’ ...
```

It did not prevent the build.

---

# 11. Create the root filesystem

Create the basic root filesystem structure:

```bash
rm -rf ~/kernel-lab/rootfs/*
mkdir -p ~/kernel-lab/rootfs
```

Install BusyBox into it:

```bash
make \
    ARCH=arm64 \
    CROSS_COMPILE=aarch64-linux-gnu- \
    CONFIG_PREFIX=~/kernel-lab/rootfs \
    install
```

We now have a small ARM64 userspace under:

```text
~/kernel-lab/rootfs/
```

For example:

```text
rootfs/
├── bin/
│   ├── busybox
│   └── ...
│
├── sbin/
├── usr/
├── etc/
└── ...
```

Check the BusyBox binary:

```bash
file ~/kernel-lab/rootfs/bin/busybox
```

It should be an ARM64 executable.

If BusyBox was configured as a static binary, it should report something similar to:

```text
ELF 64-bit LSB executable, ARM aarch64, statically linked
```

Static linking is convenient for an initramfs because we don't need to provide shared libraries.

---

# 12. Create the `/init` program

The Linux kernel needs a userspace program to start after it has initialized the system.

Create:

```bash
nano ~/kernel-lab/rootfs/init
```

Contents:

```sh
#!/bin/sh

mount -t proc none /proc
mount -t sysfs none /sys
mount -t devtmpfs none /dev

echo
echo "================================"
echo "  My ARM64 Linux kernel"
echo "================================"
echo

echo "Kernel:"
uname -a

echo
echo "Starting shell..."

exec /bin/sh
```

Make it executable:

```bash
chmod +x ~/kernel-lab/rootfs/init
```

The boot sequence is now:

```text
Linux kernel
     │
     ▼
initramfs
     │
     ▼
/init
     │
     ▼
BusyBox
     │
     ▼
/bin/sh
     │
     ▼
/ #
```

---

# 13. Create the initramfs

Enter the root filesystem:

```bash
cd ~/kernel-lab/rootfs
```

Create the compressed initramfs:

```bash
find . -print0 | \
    cpio --null -ov --format=newc | \
    gzip -9 \
    > ~/kernel-lab/images/initramfs.cpio.gz
```

We now have:

```text
~/kernel-lab/images/initramfs.cpio.gz
```

The two main files required by QEMU are:

```text
~/kernel-lab/builds/first/arch/arm64/boot/Image
~/kernel-lab/images/initramfs.cpio.gz
```

---

# 14. Boot the kernel with QEMU

Use QEMU's generic ARM64 `virt` machine:

```bash
qemu-system-aarch64 \
    -machine virt \
    -cpu cortex-a53 \
    -m 512M \
    -smp 4 \
    -kernel ~/kernel-lab/builds/first/arch/arm64/boot/Image \
    -initrd ~/kernel-lab/images/initramfs.cpio.gz \
    -append "console=ttyAMA0 rdinit=/init" \
    -nographic
```

Important parameters:

```text
-machine virt
```

Use QEMU's generic virtual ARM machine.

```text
-cpu cortex-a53
```

Emulates an ARM Cortex-A53 CPU, which is also the CPU architecture of the Raspberry Pi 3.

```text
-m 512M
```

Provides 512 MB RAM.

```text
-smp 4
```

Provides four virtual CPUs.

```text
-kernel Image
```

Loads our cross-compiled Linux kernel.

```text
-initrd initramfs.cpio.gz
```

Loads the BusyBox root filesystem.

```text
-append "console=ttyAMA0 rdinit=/init"
```

Tells Linux:

* use the QEMU serial console
* execute `/init` as the first userspace process

```text
-nographic
```

Runs QEMU entirely through the terminal.

---

# 15. Expected result

If everything is working, the kernel eventually starts BusyBox and you should see something similar to:

```text
================================
  My ARM64 Linux kernel
================================

Kernel:
Linux ...

Starting shell...
/ #
/ # uname -a
Linux (none) 6.18.49 #1 SMP PREEMPT Sun Sep  6 17:33:27 CEST 2026 aarch64 GNU/Linux

```

At this point you are running:

```text
Your Linux kernel
        +
Your ARM64 BusyBox
        +
Your initramfs
        +
QEMU ARM64 virt machine
```

---

# 16. Kernel vs BusyBox vs initramfs

It is important to keep these concepts separate.

### Kernel

Built from:

```text
~/kernel-lab/src/linux
```

Output:

```text
~/kernel-lab/builds/first/arch/arm64/boot/Image
```

The kernel controls:

* CPU
* memory
* processes
* device drivers
* filesystems
* networking
* system calls

### BusyBox

Built from:

```text
~/kernel-lab/src/busybox
```

Installed into:

```text
~/kernel-lab/rootfs/
```

BusyBox provides userspace commands such as:

```text
sh
ls
cat
mount
echo
uname
```

### Initramfs

Created from:

```text
~/kernel-lab/rootfs/
```

Output:

```text
~/kernel-lab/images/initramfs.cpio.gz
```

It provides the initial userspace filesystem that Linux mounts during boot.

---

# 17. Recommended development workflow

Once the basic system works, the workflow becomes:

```text
                 ┌──────────────────┐
                 │ Linux source     │
                 └────────┬─────────┘
                          │
                          ▼
                    .config
                          │
                          ▼
                 cross compilation
                          │
                          ▼
                       Image
                          │
                          │
                          ├──────────────┐
                          │              │
                          ▼              ▼
                    QEMU virt       initramfs
                                      │
                                      ▼
                                   BusyBox
                                      │
                                      ▼
                                    /init
                                      │
                                      ▼
                                   /bin/sh
```

When experimenting with the kernel:

```bash
make -C ~/kernel-lab/src/linux \
    O=~/kernel-lab/builds/first \
    ARCH=arm64 \
    CROSS_COMPILE=aarch64-linux-gnu- \
    menuconfig
```

Then rebuild:

```bash
make -C ~/kernel-lab/src/linux \
    O=~/kernel-lab/builds/first \
    ARCH=arm64 \
    CROSS_COMPILE=aarch64-linux-gnu- \
    -j"$(nproc)"
```

Then boot QEMU again.

---

# 18. Recommended next steps

Once this basic setup works, progressively experiment with:

1. **Kernel `.config`**

   * Remove unnecessary drivers.
   * Compare `defconfig` with minimal configurations.
   * Learn kernel configuration dependencies.

2. **Kernel boot parameters**

   * `console=`
   * `init=`
   * `rdinit=`
   * memory parameters
   * CPU parameters

3. **Initramfs**

   * Add programs.
   * Add scripts.
   * Add configuration files.
   * Add device nodes.
   * Add networking.

4. **QEMU hardware**

   * virtual disks
   * networking
   * virtio devices
   * multiple CPUs
   * different RAM sizes

5. **Kernel debugging**

   * kernel log messages
   * `CONFIG_DEBUG_KERNEL`
   * QEMU + GDB
   * breakpoints during kernel boot

6. **Kernel modules**

   * build a simple module
   * load it from BusyBox
   * inspect `/proc/modules`
   * experiment with module parameters

7. **Kernel development**

   * modify existing kernel code
   * write a simple driver
   * add `printk()` debugging
   * study system calls
   * study scheduling and memory management

---

## Final target

The long-term goal is to have a simple command such as:

```bash
./build-and-run.sh
```

which performs:

```text
Linux source
     │
     ▼
configure
     │
     ▼
cross compile
     │
     ▼
ARM64 Image
     │
     ├──────────────┐
     │              │
     ▼              ▼
initramfs       BusyBox
     │              │
     └──────┬───────┘
            ▼
          QEMU
            │
            ▼
          / #
```

This gives you a safe and repeatable environment for experimenting with Linux kernels without modifying the physical Raspberry Pi.


