# Module 1 systemd

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

## Lab 3

Create three services:

- database.service
- backend.service
- frontend.service

Each service should simply:
    echo Started <name> into /tmp/startup.log


/etc/systemd/system/database.service
```ini
[Unit]
Description=Dependency Lab Database

[Service]
Type=oneshot
ExecStart=/usr/bin/bash -c 'echo "$(date): Started database" >> /tmp/startup.log'

[Install]
WantedBy=multi-user.target
```

/etc/systemd/system/backend.service
```ini
[Unit]
Description=Dependency Lab Backend
Requires=database.service
After=database.service

[Service]
Type=oneshot
ExecStart=/usr/bin/bash -c 'echo "$(date): Started backend" >> /tmp/startup.log'
```

/etc/systemd/system/frontend.service
```ini
[Unit]
Description=Dependency Lab Frontend
Requires=backend.service
After=backend.service

[Service]
Type=oneshot
ExecStart=/usr/bin/bash -c 'echo "$(date): Started frontend" >> /tmp/startup.log'
```

## Lab 4 

Instead of cron, create a timer that writes current time every minute.

/etc/systemd/system/lab-timer.service
```ini
[Unit]
Description=Timer service

[Service]
ExecStart=/usr/bin/bash -c 'echo "Current time: $(date +"%T") >> /tmp/timer.log"'
```

/etc/systemd/system/lab-timer.timer
```ini
[Unit]
Description=Run every minute

[Timer]
OnCalendar=*-*-* *:*:00
Unit=lab-timer.service
Persistent=true

[Install]
WantedBy=timers.target
```

Check all timers enabled in the system:
```shell
    $ systemctl list-timers
```

## Lab 5

Practice journalctl (persistent logs)

By default, Ubuntu often stores logs only in memory unless /var/log/journal exists.

```shell
ls -ld /var/log/journal
```

if exists, logs are persistent.

if not, create it:
```shell
sudo mkdir -p /var/log/journal
sudo systemd-tmpfiles --create --prefix /var/log/journal
sudo systemctl restart systemd-journald
```

Verify:

```shell
journalctl --disk-usage
```

1. logs since boot

```shell
journalctl -b
```

2. logs of one service

```shell
journalctl -u <service name>
```

3. previous boot

```shell
journalctl --list-boots

journalctl -b 1
```

4. last five minutes

```shell
journalctl --sice "5 minutes ago"
```

5. Show error logs:
```shell
journalctl -p err

journalctl -p warning

journalctl -p crit
```

# Module 2 systemd-nspawn

## LAb 6

Build an Ubuntu noble container:

```shell
sudo debootstrap noble ~/systemd-labs/containers/lab http://archive.ubuntu.com/ubuntu
```
```shell
sudo systemd-nspawn -D ~/systemd-labs/containers/lab -b
```

```shell
$ antonio (linux) >machinectl 
MACHINE CLASS     SERVICE        OS     VERSION ADDRESSES
lab     container systemd-nspawn ubuntu 24.04   -        

1 machines listed.
```

It requires a password to login, so instead we are going to start the container this way:

```shell
sudo systemd-nspawn \
    -M lab \
    -D ~/systemd-labs/containers/lab \
    -b
```

and now enter the container directly:

```shell
sudo machinectl shell root@lab
```

Inside the container

1. install htop

```shell
root@xps-ubuntu:~# apt update && install htop

root@xps-ubuntu:~# dpkg -l htop
Desired=Unknown/Install/Remove/Purge/Hold
| Status=Not/Inst/Conf-files/Unpacked/halF-conf/Half-inst/trig-aWait/Trig-pend
|/ Err?=(none)/Reinst-required (Status,Err: uppercase=bad)
||/ Name           Version       Architecture Description
+++-==============-=============-============-=================================
ii  htop           3.3.0-4build1 amd64        interactive processes viewer

```
2. create user
```shell
root@xps-ubuntu:~# adduser dummy
```
3. enable ssh
```shell
root@xps-ubuntu:~# apt install openssh-server
root@xps-ubuntu:~# systemctl enable ssh

root@xps-ubuntu:~# systemctl is-enabled ssh
enabled
```

## Lab 8

Bind mounts: exposing ~/shared inside container as /mnt/shared

```shell
systemd-nspawn \
-D ~/systemd-labs/containers/lab \
--bind=$HOME/shared:/mnt/shared
```

## Lab 9

Lab 9 introduces one of the biggest differences between containers and VMs: networking is provided by the host. In systemd-nspawn, there are several networking modes, and --network-veth is the most commonly used for giving the container its own virtual Ethernet interface.

```shell
sudo systemd-nspawn \
    -M lab \
    -D ~/systemd-labs/containers/lab \
    -b \
    --network-veth
```
This creates a veth pair:

```shell
Host                     Container

ve-lab  <-------------> host0
```

- ve-lab exists on the host.
- host0 exists inside the container.

They behave like a virtual Ethernet cable.

Check on the container:
```shell
ip link
ip addr show host0
```

If there is no IPv4 address, that's expected on many Ubuntu systems. --network-veth only creates the virtual link; it does not automatically provide DHCP or NAT. You need additional host-side networking (for example, systemd-networkd, a bridge, or manual configuration) for the container to obtain an address.



# UKI

Pakcages needed:

```shell
sudo apt install \
    systemd-boot-efi \
    dracut \
    ukify
```
