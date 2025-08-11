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

Self-configuration in IPv6 is one of its key features, enabling devices to automatically configure their own network settings without requiring a DHCP (Dynamic Host Configuration Protocol) server. This process allows for easier network setup, especially in environments where devices frequently join and leave the network.

There are two main methods for IPv6 address configuration:

1. Stateless Address Autoconfiguration (SLAAC)

2. Stateful Address Configuration (DHCPv6)


Self-configuration in IPv6, or SLAAC, allows a device to automatically generate an IPv6 address and configure its network settings using the information advertised by routers. Here’s how it works:

1. Router Advertisement (RA)

    When a device connects to an IPv6 network, it listens for Router Advertisements (RAs), which are periodically sent by routers on the network. These RAs provide important information about the network, including:

    - Prefix (network identifier).

    - The presence of a DHCPv6 server (if required for stateful configuration).

    - Whether the device should use SLAAC or DHCPv6 for address configuration.

2. Address Generation

    The device uses the prefix provided in the RA and combines it with its MAC address (or a randomly generated interface identifier) to create its IPv6 address.

    - This is done using the Modified EUI-64 format (extended unique identifier).

    - The result is an IPv6 address with a global scope, such as 2001:db8::1234:5678.

3. Duplicate Address Detection (DAD)

    Before the device can use its newly generated IPv6 address, it performs Duplicate Address Detection (DAD) to ensure that the address is not already in use on the network. If no duplicate is found, the address is considered valid and can be used for communication.

4. Routing and Connectivity

    The device can now communicate with other devices within the same network or even beyond, using the router as a gateway.

    The device will periodically check for new Router Advertisements to update its configuration if needed.

5. Optional DHCPv6 for Additional Settings

    Although the device can configure its address and basic settings via SLAAC, it may still use DHCPv6 for additional information, like DNS servers or other configuration parameters. This is common in larger networks that require more control over IP address assignments.

Advantages of Self-Configuration (SLAAC)

- No Need for a DHCP Server
SLAAC allows devices to automatically configure themselves without relying on a central DHCP server. This reduces the administrative burden and makes it easier to scale large networks.

- Faster Setup
Devices can automatically join the network and begin using IPv6 addresses without waiting for a DHCP server to assign an address.

- Improved Mobility
Because devices generate their own addresses based on their network environment, they can easily move between networks and reconfigure their addresses accordingly.

- Reduced Network Overhead
Since there's no need for a DHCP server in SLAAC, there is less communication overhead between devices and servers, making the process quicker and more efficient.

----------------------------------

Example of Self-Configuration Process (SLAAC)

- Step 1: Router Sends RA
A router on the network periodically sends an RA packet that contains the prefix 2001:db8::/64.

- Step 2: Device Generates IPv6 Address
A device connects to the network and generates an address based on the RA. If its MAC address is 00:11:22:33:44:55, it will generate an address like:

    ```shell
    2001:db8::211:22ff:fe33:4455
    ```

- Step 3: Duplicate Address Detection (DAD)
The device checks if the address is already in use. If not, it proceeds with the address.

- Step 4: Device Can Now Communicate
The device is now configured with an IPv6 address and can communicate with other devices in the network, using the router as the default gateway.

## Network Types

- LAN (Local area network -- Switch)

- WAN (Wide area network --Router)

- CAN (Campus area network)

- MAN (Metropolitan area network)

- Intranet (private internet)

- WLAN (Wireless local area network)

- PAN (Personal area network -- Bluetooth)

## VoIP


## VPNs



