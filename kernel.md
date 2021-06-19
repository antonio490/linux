
# Kernel compilation from source code


1. Download the kernel

<code>

    $ wget https://git.kernel.org/torvalds/t/linux-4.17-rc2.tar.gz

</code>


2. Extract the source

<code>

    $ tar xvzf linux-4.17-rc2.tar.gz

</code>

Before we actually compile the kernel, we must first configure which modules to include. There is actually a really easy way to do this. With a single command, you can copy the current kernel’s config file and then use the tried and true menuconfig command to make any necessary changes. To do this, issue the command:

<code>

    $ cp /boot/config-$(uname -r) .config

</code>


<code>

    $ make menuconfig

</code>

After answering the litany of questions, you can compile and install the modules you’ve enabled with the command:

<code>

    $ make -j <cpu_cores>

</code>

<code>

    $ make modules_install

</code>

<code>

    $ make install

</code>

Enable the kernel for boot

Once the make install command completes, it’s time to enable the kernel for boot. To do this, issue the command:

<code>

    $ update-initramfs -c -k 4.17-rc2

</code>

Of course, you would substitute the kernel number above for the kernel you’ve compiled. When that command completes, update grub with the command:

<code>

    $ update-grub

</code>

You should now be able to restart your system and select the newly installed kernel.

