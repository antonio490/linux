
# Debian Package Management

Efforts to distribute software "packages" grew, and the first package managers were born. These tools made it much easier to install, configure or remove software from a system.

One of those was the Debian package format (.deb) and its package tool (dpkg). Antoher package management tool that is popular on Debiand-based itself is the Advanced Package Tool (apt).


## Debian Package Tool (dpkg)

Essential utility to install, configure, maintain, and remove software packages on Debian-based systems.

    # dpkg -i PACKAGENAME.deb

Package upgrades are handled the same way.

### Dealing with dependencies

Often, a pacalge may depend on others to work as intented. In this case <code>dpkg</code> will list which packages are missing. However it cannot solve dependencies by itself.

    # dpkg -i openshot-qt_2.4.3+dfsg1-1_all.deb
    (Reading database ... 269630 files and directories currently installed.)
    Preparing to unpack openshot-qt_2.4.3+dfsg1-1_all.deb ...
    Unpacking openshot-qt (2.4.3+dfsg1-1) over (2.4.3+dfsg1-1) ...
    dpkg: dependency problems prevent configuration of openshot-qt:
    openshot-qt depends on fonts-cantarell; however:
    Package fonts-cantarell is not installed.

### Removing Packagess

To remove a package pass the -r parameter to dpkg, followed bz the pacakge name:

    # dpkg -r unrar

The removal operation also runs a dependency check, and a package cannot be removed unless every other package that depends on it it is also removed.

    # dpkg -r p7zip
    dpkg: dependency problems prevent removal of p7zip:
    winetricks depends on p7zip; however:
    Package p7zip is to be removed.

*NOTE*

You can force dpkg to install or remove a package, even if dependencies are not
met, by adding the --force parameter like in dpkg -i --force PACKAGENAME.
However, doing so will most likely leave the installed package, or even your
system, in a broken state. Do not use --force unless you are absolutely sure of
what you are doing.

### Getting package information

To get information about a .deb package, such as its version, architecture, maintainer, dependencies
and more, use the dpkg command with the -I parameter, followed by the filename of the package
you want to inspect:

    # dpkg -I google-chrome-stable_current_amd64.deb

    new Debian package, version 2.0.
    size 59477810 bytes: control archive=10394 bytes.
    1222 bytes,13 lines
    control
    16906 bytes,457 lines*postinst#!/bin/sh
    12983 bytes,344 lines*postrm#!/bin/sh
    1385 bytes,42 lines*prerm#!/bin/sh
    Package: google-chrome-stable
    Version: 76.0.3809.100-1
    Architecture: amd64
    Maintainer: Chrome Linux Team <chromium-dev@chromium.org>
    Installed-Size: 205436
    Pre-Depends: dpkg (>= 1.14.0)
    ...

### Listing installed Packages and Package content

To get a list of every package installed on your system, use the --get-selections option, as in dpkg
--get-selections. You can also get a list of every file installed by a specific package by passing the
-L PACKAGENAME parameter to dpkg, like below:

    # dpkg -L unrar
    /.
    /usr
    /usr/bin
    /usr/bin/unrar-nonfree
    /usr/share
    /usr/share/doc
    /usr/share/doc/unrar
    /usr/share/doc/unrar/changelog.Debian.gz
    /usr/share/doc/unrar/copyright
    /usr/share/man
    /usr/share/man/man1
    /usr/share/man/man1/unrar-nonfree.1.gz  

## Finding Out Which Package Owns a Specific File

Sometimes you may need to find out which package owns a specific file in your system. You can do
so by using the dpkg-query utility, followed by the -S parameter and the path to the file in question:

    # dpkg-query -S /usr/bin/unrar-nonfree
    unrar: /usr/bin/unrar-nonfree 

## Advanced Package Tool (apt)

The advanced Package Tool (APT) is a package management system, including a set of tools, that greatly
simplifies package installation, upgrade, removal and management. APT provdies features like advanced search capabilities and automatic dependecy resolution.

APT is not a substitute for dpkg, we may think it as a front end, filling gaps such as the dependency resolution.

There are many utilities that interact with APT, the main ones being:
    
    # apt-get
    used to download, install, upgrade or remove packages from the system.

    # apt-cache
    used to perform operations, like searches, in the package index.

    # apt-file
    used for searching for files inside packages.

*NOTE*

<code> apt </code> and <code> apt-get </code> may require a network connection, because packages and package indexes may need to be downloaded from a remote server.

### Updating the Package Index
Before installing or upgrading software with APT, it is recommended to update the package index
first in order to retrieve information about new and updated packages. This is done with the apt-get
command, followed by the update parameter:

    # apt-get update
    Ign:1 http://dl.google.com/linux/chrome/deb stable InRelease
    Hit:2 https://repo.skype.com/deb stable InRelease
    Hit:3 http://us.archive.ubuntu.com/ubuntu disco InRelease
    Hit:4 http://repository.spotify.com stable InRelease
    Hit:5 http://dl.google.com/linux/chrome/deb stable Release
    Hit:6 http://apt.pop-os.org/proprietary disco InRelease
    Hit:7 http://ppa.launchpad.net/system76/pop/ubuntu disco InRelease
    Hit:8 http://us.archive.ubuntu.com/ubuntu disco-security InRelease
    Hit:9 http://us.archive.ubuntu.com/ubuntu disco-updates InRelease
    Hit:10 http://us.archive.ubuntu.com/ubuntu disco-backports InRelease
    Reading package lists... Done

- Instead of <code> apt-get update </code>, you can also use <code> apt update </code>.

### Installing and Removing Packages

With the package index updated you may now install a package. This is done with apt-get install,
followed by the name of the package you wish to install:

    # apt-get install xournal
    Reading package lists... Done
    Building dependency tree
    Reading state information... Done
    The following NEW packages will be installed:
    xournal
    0 upgraded, 1 newly installed, 0 to remove and 75 not upgraded.
    Need to get 285 kB of archives.
    After this operation, 1041 kB of additional disk space will be used.

Be aware that when installing or removing packages, APT will do automatic dependency resolution.
This means that any additional packages needed by the package you are installing will also be
installed, and that packages that depend on the package you are removing will also be removed. APT
will always show what will be installed or removed before asking if you want to continue:
    
    # apt-get remove p7zip
    Reading package lists... Done
    Building dependency tree
    The following packages will be REMOVED:
    android-libbacktrace android-libunwind android-libutils
    android-libziparchive android-sdk-platform-tools fastboot p7zip p7zip-full
    0 upgraded, 0 newly installed, 8 to remove and 75 not upgraded.
    After this operation, 6545 kB disk space will be freed.
    Do you want to continue? [Y/n]

Note that when a package is removed the corresponding configuration files are left on the system.
To remove the package and any configuration files, use the purge parameter instead of remove or the
remove parameter with the <code> --purge </code> option:
    
    # apt-get purge p7zip
    # apt-get remove --purge p7zip

- You can also use apt install and apt remove.

### Fixing Broken Dependencies

It is possible to have “broken dependencies” on a system. This means that one or more of the
installed packages depend on other packages that have not been installed, or are not present
anymore. This may happen due to an APT error, or because of a manually installed package.
To solve this, use the <code> apt-get install -f </code> command. This will try to “fix” the broken packages by installing the missing dependencies, ensuring that all packages are consistent again.

- You can also use <code> apt install -f </code>.

### Upgrading Packages

APT can be used to automatically upgrade any installed packages to the latest versions available
from the repositories. This is done with the apt-get upgrade command. Before running it, first
update the package index with <code> apt-get update </code>:

    # apt-get update
    Hit:1 http://us.archive.ubuntu.com/ubuntu disco InRelease
    Hit:2 http://us.archive.ubuntu.com/ubuntu disco-security InRelease
    Hit:3 http://us.archive.ubuntu.com/ubuntu disco-updates InRelease
    Hit:4 http://us.archive.ubuntu.com/ubuntu disco-backports InRelease
    Reading package lists... Done

To upgrade a single package, just run apt-get upgrade followed by the package name. As in dpkg,
apt-get will first check if a previous version of a package is installed. If so, the package will be
upgraded to the newest version available in the repository. If not, a fresh copy will be installed.

- You can also use <code> apt upgrade </code> and <code> apt update </code>.

### The Local Cache

When you install or update a package, the corresponding .deb file is downloaded to a local cache
directory before the package is installed. By default, this directory is /var/cache/apt/archives.
Partially downloaded files are copied to /var/cache/apt/archives/partial/.
As you install and upgrade packages, the cache directory can get quite large. To reclaim space, you
can empty the cache by using the <code> apt-get clean </code> command. This will remove the contents of the /var/cache/apt/archives and /var/cache/apt/archives/partial/ directories.

- You can also use <code> apt clean </code>.

### Searching for Packages

The apt-cache utility can be used to perform operations on the package index, such as searching for
a specific package or listing which packages contain a specific file.

To conduct a search, use apt-cache search followed by a search pattern. The output will be a list of
every package that contains the pattern, either in its package name, description or files provided.

    # apt-cache search p7zip
    liblzma-dev - XZ-format compression library - development files
    liblzma5 - XZ-format compression library
    forensics-extra - Forensics Environment - extra console components (metapackage)
    p7zip - 7zr file archiver with high compression ratio
    p7zip-full - 7z and 7za file archivers with high compression ratio
    p7zip-rar - non-free rar module for p7zip

- You can also use <code> apt search </code> instead of <code> apt-cache search </code> and <code> apt show </code> instead of <code> apt-cache show </code>.

### The Sources List

APT uses a list of sources to know where to get packages from. This list is stored in the file sources.list, located inside the /etc/apt directory. This file can be edited directly with a text editor, like vi, pico or nano, or with graphical utilities like aptitude or synaptic. A typical line inside sources.list looks like this:

    deb http://us.archive.ubuntu.com/ubuntu/ disco main restricted universe multiverse

*NOTE*

You can learn more about the Debian Free
Software Guidelines at: https://www.debian.org/social_contract#guidelines

To add a new repository to get packages from, you can simply add the corresponding line (usually provided by the repository maintainer) to the end of sources.list, save the file and reload the package index with apt-get update. After that, the packages in the new repository will be available for installation using apt-get install.

### The /etc/apt/sources.list.d Directory

Inside the /etc/apt/sources.list.d directory you can add files with additional repositories to be used by APT, without the need to modify the main /etc/apt/sources.list file. These are simple text files, with the same syntax described above and the .list file extension.

Below you see the contents of a file called /etc/apt/sources.list.d/buster-backports.list:

    deb http://deb.debian.org/debian buster-backports main contrib non-free
    deb-src http://deb.debian.org/debian buster-backports main contrib non-free

### Listing Package Contents and Finding Files

A utility called apt-file can be used to perform more operations in the package index, like listing the contents of a package or finding a package that contains a specific file. This utility may not be installed by default in your system. In this case, you can usually install it using apt-get:

    # apt-get install apt-file

After installation, you will need to update the package cache used for apt-file:

    # apt-file update


### Exercises

1. What is the command to install a package named package.deb using dpkg?

    dpkg -i package.deb

2. Using dpkg-query, find which package containe a file name 7zr.1.gz

    dpkg-query -S 7zr.1.gz

3. Can you remove a package called unzip from the system using dpkg -r unzop if the package file-roller depends on it? If not, what would the correct way to do it?

    dpkg -r file-roller unzip

4. Using apt-file, how can you find out which package contains the file unrar?

    apt-file search /usr/bin/unrar

5. Using apt-cache, what is the command to show information for the package gimp?

    apt-cache show gimp


# RPM and YUM Package Management

Efforts to standardize a way to distribute these software “packages” grew, and the first package
managers were born. These tools made it much easier to install, configure or remove software from a
system.

One of those was the RPM Package Manager and its corresponding tool (rpm), developed by Red Hat.
Today, they are widely used not only on Red Hat Enterprise Linux (RHEL) itself, but also on its
descendants, like Fedora, CentOS and Oracle Linux, other distributions like openSUSE and even
other operating systems, like IBM’S AIX.

Other package management tools popular on Red Hat compatible distros are yum (YellowDog Updater Modified), dnf (Dandified YUM) and zypper, which can streamline many of the aspects of
the installation, maintenance and removal of packages, making package management much easier.
In this lesson, we will learn how to use rpm, yum, dnf and zypper to obtain, install, manage and
remove software on a Linux system.