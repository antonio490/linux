
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
