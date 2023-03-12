#!/bin/bash

# create two net namespaces
ip netns add ns1
ip netns add ns2

# print namespaces 
# ip netns list

# assign interfaces to network namespaces
# virtual interfaces always comes in pairs,
# and they are connected like a tube -whatever
# comes in one veth interface will come out the
# other peer veth interface.
ip link add veth0 type veth peer name veth1

# print the veth pair
# ip link list

# configure interfaces
ip link set veth0 netns ns1
ip netns exec ns1 ip link set dev veth0 up
ip netns exec ns1 ip link set dev lo up
ip -n ns1 addr add 10.0.0.1/24 dev veth0

ip link set veth1 netns ns2
ip netns exec ns2 ip link set dev veth1 up
ip netns exec ns2 ip link set dev lo up
ip -n ns2 addr add 10.0.0.2/24 dev veth1


# routing configuration
echo 1 > /proc/sys/net/ipv4/ip_forward

# test ping
ip netns exec ns1 ping 10.0.0.2 -c4
ip netns exec ns2 ping 10.0.0.1 -c4


# remove net namespaces
ip netns delete ns1
ip netns delete ns2

# <docs>
# 1) https://blog.scottlowe.org/2013/09/04/introducing-linux-network-namespaces/

