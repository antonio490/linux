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


