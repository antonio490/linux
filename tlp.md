# TLP

## Unmask, enable and start tlp service

    (base) antonio@xps-ubuntu:~$ sudo systemctl unmask tlp.service
    Removed /etc/systemd/system/tlp.service.

    (base) antonio@xps-ubuntu:~$ sudo systemctl enable tlp.service 
    Synchronizing state of tlp.service with SysV service script with /lib/systemd/systemd-sysv-install.
    Executing: /lib/systemd/systemd-sysv-install enable tlp

    (base) antonio@xps-ubuntu:~$ sudo systemctl status tlp.service 
    ● tlp.service - TLP system startup/shutdown
        Loaded: loaded (/lib/systemd/system/tlp.service; enabled; vendor preset: enabled)
        Active: active (exited) since Wed 2023-11-08 20:08:11 CET; 3s ago
        Docs: https://linrunner.de/tlp
        Process: 50433 ExecStart=/usr/sbin/tlp init start (code=exited, status=0/SUCCESS)
    Main PID: 50433 (code=exited, status=0/SUCCESS)
            CPU: 242ms

    nov 08 20:08:11 xps-ubuntu systemd[1]: Starting TLP system startup/shutdown...
    nov 08 20:08:11 xps-ubuntu tlp[50433]: Applying power save settings...done.
    nov 08 20:08:11 xps-ubuntu tlp[50433]: Setting battery charge thresholds...done.
    nov 08 20:08:11 xps-ubuntu systemd[1]: Finished TLP system startup/shutdown.


You following TLP command lets you view detailed system information and also the status of the TLP utility:


    (base) antonio@xps-ubuntu:~$ sudo tlp-stat -s
    --- TLP 1.5.0 --------------------------------------------

    +++ System Info
    System         = Dell Inc.  XPS 13 9310
    BIOS           = 1.0.3
    OS Release     = Ubuntu 22.04.3 LTS
    Kernel         = 6.3.0-060300-generic #202304232030 SMP PREEMPT_DYNAMIC Sun Apr 23 20:37:49 UTC 2023 x86_64
    /proc/cmdline  = BOOT_IMAGE=/boot/vmlinuz-6.3.0-060300-generic root=UUID=f162cd75-4251-4ba5-aba0-8f91e6081fa4 ro quiet splash vt.handoff=7
    Init system    = systemd v249 (249.11-0ubuntu3.11)
    Boot mode      = UEFI

    +++ TLP Status
    State          = enabled
    RDW state      = enabled
    Last run       = 20:08:11,     12 sec(s) ago
    Mode           = battery (persistent)
    Power source   = AC


    (base) antonio@xps-ubuntu:~$ sudo tlp-stat -s
    --- TLP 1.5.0 --------------------------------------------

    +++ System Info
    System         = Dell Inc.  XPS 13 9310
    BIOS           = 1.0.3
    OS Release     = Ubuntu 22.04.3 LTS
    Kernel         = 6.3.0-060300-generic #202304232030 SMP PREEMPT_DYNAMIC Sun Apr 23 20:37:49 UTC 2023 x86_64
    /proc/cmdline  = BOOT_IMAGE=/boot/vmlinuz-6.3.0-060300-generic root=UUID=f162cd75-4251-4ba5-aba0-8f91e6081fa4 ro quiet splash vt.handoff=7
    Init system    = systemd v249 (249.11-0ubuntu3.11)
    Boot mode      = UEFI

    +++ TLP Status
    State          = enabled
    RDW state      = enabled
    Last run       = 20:10:19,    103 sec(s) ago
    Mode           = battery (persistent)
    Power source   = battery
