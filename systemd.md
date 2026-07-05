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

# UKI

Pakcages needed:

```shell
sudo apt install \
    systemd-boot-efi \
    dracut \
    ukify
```
