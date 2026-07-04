# systemd

## Lab 1

Packages needed: 

```shell

sudo apt update

sudo apt install \
    systemd-container \
    debootstrap \
    arch-install-scripts \
    qemu-utils \
    dosfstools \
    gdisk \
    binutils \
    efibootmgr \
    ovmf \
    qemu-system-x86
```

1. List all running services:

```shell
$ systemctl list-units --type=service
```

2. Find failed services.

```shell
$ systemctl --failed
```
3. Determine the default target.

```shell
$ systemctl get-default
```

4. Display the boot critical path.

```shell
$ systemd-analyze critical-chain
```

5. Find the slowest service.

```shell
$ systemd-analize blame
```

6. Set a default target.

```shell
$ systemctl set-deafult multi-user.target
```

### Notes:

A target in systemd is a special type of unit file (ending in .target) used to group other units together and establish system states. They act as synchronization points during the boot process, dictating which services need to be active to reach a specific milestone.

- multi-user.target: Represents a fully booted system with a command-line interface but no graphical environment. It is the standard target for headless servers.

- graphical.target: Includes all services from multi-user.target but adds display managers and desktop environment services. This is the default for desktop Linux systems.

rescue.target or emergency.target: Minimal environments used for diagnostics, repairs, and troubleshooting where only the root user logs in.

## Lab 2

Create a service that runs "Hello world!" into /tmp/systemd-lab.log every reboot.

/etc/systemd/system/lab.service

```ini 
[Unit]
Description=Systemd Lab

[Service]
Type=oneshot
ExecStart=/usr/bin/bash -c 'echo Hello from systemd! >> /tmp/systemd-lab.log'

[Install]
WantedBy=multi-user.target
```

```shell
sudo systemctl daemon-reload
sudo systemctl enable lab.service
sudo systemctl start lab.service
```


# UKI

Pakcages needed:

```shell
sudo apt install \
    systemd-boot-efi \
    dracut \
    ukify
```
