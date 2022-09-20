
# Linux Interfaces

Linux has rich virtual networking capabilities that are used as basis for hosting VMs and containers, as well as cloud environments. In this post, I will give a brief introduction to all commonly used virtual network interface types. There is no code analysis, only a brief introduction to the interfaces and their usage on Linux. Anyone with a network background might be interested in this blog post. A list of interfaces can be obtained using the command `ip link help`.

## Bridge

A Linux bridge behaves like a network switch. It forwards packets between interfaces that are connected to it. It's usually used for forwarding packets on routers, on gateways, or between VMs and network namespaces on a host. It also supports STP, VLAN filter, and multicast snooping.

    # ip link add br0 type bridge
    # ip link set eth0 master br0
    # ip link set tap1 master br0
    # ip link set tap2 master br0
    # ip link set veth1 master br0

This creates a bridge device named br0 and sets two TAP devices (tap1, tap2), a VETH device (veth1), and a physical device (eth0) as its slaves, as shown in the diagram above.

## VLAN

A VLAN, aka virtual LAN, separates broadcast domains by adding tags to network packets. VLANs allow network administrators to group hosts under the same switch or between different switches.

Here's how to create a VLAN:

    # ip link add link eth0 name eth0.2 type vlan id 2
    # ip link add link eth0 name eth0.3 type vlan id 3

This adds VLAN 2 with name eth0.2 and VLAN 3 with name eth0.3. The topology looks like this:

