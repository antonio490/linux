# Communications systems

## IPv6

IPv6 address: ff01:0000:0000:0001:445f:fff0:1122:0022 (128 bits) 

2^128 -- Much more address space than IPv4
IPv6 addresses can be shortened by removing leading zeros.

Link local addresses


### Aggregation
Network aggregation in IPv6, also known as route summarization or prefix aggregation, is a method used to reduce the number of routing table entries by combining multiple smaller networks into a larger, single route. This improves network efficiency and scalability.

IPv6 addresses follow a hierarchical structure that allows for easy aggregation. For example, an ISP can allocate a large address block (e.g., 2001:db8::/32) and then divide it among its customers (2001:db8:1::/48, 2001:db8:2::/48, etc.).

Instead of announcing multiple specific routes (2001:db8:1::/48, 2001:db8:2::/48, etc.), an ISP can advertise a single summarized route (2001:db8::/32), reducing the number of entries in routing tables.

Benefits of aggregation:

- Smaller Routing Tables: Reduces memory and processing overhead for routers.

- Efficient Routing: Decreases the number of routing updates and improves network stability.

- Scalability: Allows ISPs and large enterprises to manage large networks more efficiently.

Example:

Imagine an ISP has assigned these prefixes to its customers:

```shell
2001:db8:1::/48
2001:db8:2::/48
2001:db8:3::/48
2001:db8:4::/48
```

Instead of advertising all four routes, the ISP can aggregate them into a single summarized route:

```shell
2001:db8::/46
```

This route covers all the addresses from 2001:db8:0:: to 2001:db8:3::, effectively reducing the number of routing entries.

### Self configuration
With IPv6 NAT, DHCP and ARP is no longer really needed. It is all been replace with the Neighbor discovery protocol.

--------

---- Local

<- NS: Neighbour solicitation message

-> NA: Neighbour advertisement message

---- Internet

<- RS: Router solicitation message

-> RA: Router advertisement message