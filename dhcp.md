# DHCP

## What it is?

A DHCP server automatically gives devices the network settings they need to communicate. That usually means:

- an IP address

- a subnet mask

- a default gateway

- DNS servers

- And how long they can use them (lease time)

### Install and configure dhcp server

```bash
$ apt update
$ apt install isc-dhcp-server
```

```bash
$ nano /etc/default/isc-dhcp-server

# Add the interface name used
INTERFACESv4="enp0s3"
```



```bash
$ nano /etc/dhcp/dhcpd.conf

authoritative;

default-lease-time 600;
max-lease-time 7200;

subnet 192.168.50.0 netmask 255.255.255.0 {
    range 192.168.50.100 192.168.50.150;
    option routers 192.168.50.1;
    option subnet-mask 255.255.255.0;
    option domain-name-servers 8.8.8.8, 1.1.1.1;
    option domain-name "lab.local";
}
```



