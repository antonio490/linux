
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

# RPM and YUM Package Management