## TCP perfomance with sysctl

With sysctl is possible to configure kernel parameters:

- Device parameters         
- Network parameters
- Firewall parameters   
- File system
- NFS
- Processes

List of all parameters:

```js
sysctl -a
```


| Layer | Type of data |
|:---------------:|----------|
| Transport Layer | Segments |
| Network Layer   | Packets  |
| Data Link Layer | Frames   |

### Bandwidth delay product BDP

> BDP = BW x RTT

If the receiver window is less than the BDP then the connection is wasting resources.

Brandwidth delay product will go on increasing if the latency RTT is higher.

Open sysclt.conf and modify this values:

```js
    tcp_window.scaling = 1
    net.core.rmem_max = 1677216 (1Gbi)
    net.core.wmem_max = 1677216 (1Gbi)
    net.ipv4.tcp_rmem = 4096    87580   1677216
    net.ipv4.tcp_wmem = 4096    8750    1677216
```

```js
sysctl -p /etc/sysctl.conf
```


## Network tunning performance

### TCP settings:

Increase TCP window size: Modify the `net.core.wmem_max`, `net.core.rmem_max`, and `net.ipv4.tcp_wmem` kernel parameters to increase the maximum TCP window size.

> What is the TCP window size?

The TCP window size, also known as the receive window, is a parameter used in the TCP (Transmission Control Protocol) protocol to control the amount of data that can be sent by a sender before receiving an acknowledgment from the receiver. It represents the amount of buffer space available on the receiving side to hold incoming data.

Enable TCP fast open: Set `net.ipv4.tcp_fastopen` to 3 to enable TCP fast open, which can reduce connection establishment latency.

> What is TCP Fast Open?

TCP Fast Open (TFO) is an extension to the TCP (Transmission Control Protocol) protocol that aims to reduce the latency of establishing a TCP connection. Traditionally, the TCP three-way handshake is used to establish a connection between a client and a server, which involves three packets being exchanged between the two endpoints. TFO allows data to be exchanged during the initial connection establishment, reducing the number of round trips required.

It's important to note that both the client and the server need to support TCP Fast Open for it to work. The support can be enabled in the operating system or application configurations. Additionally, TFO is subject to certain security considerations and may not be suitable for all scenarios.

Enable TCP congestion control algorithms: Experiment with different congestion control algorithms using `net.ipv4.tcp_congestion_control` parameter. Common options include Cubic, BBR, and Vegas.

Increase TCP maximum backlog: Modify the `net.core.somxconn` parameter to increase the maximum number of pending connections.

### Optimize network interface settings:

Disable IPv6 if not in use: If your network infraestructure does not support IPv6, disable it by setting `net.ipv6.conf.all.disable_ipv6` and `net.ipv6.conf.default.disable_ipv6` to 1.

Disable unnecessary network protocols and services: Identify and disable any unused protocols or services to reduce network overhead.

Adjust the MTU size: If you are using Jumbo frames or have specific network requirements, consider adjusting the Maximum Transmission Unit size using the ip command. 

```js
ip link set mtu <value> dev <if_name>
```

### Enable kernel-level optimizations

Increase the network buffers: Modify the `net.core.netdev_max_backlog`, `net.core.optmem_max`, and `net.ipv4.udp_mem` parameters to increase network buffer sizes.

Enable receive packet steering (RPS): RPS distributes incoming network traffic accross multiple CPU cores, reducing the load on a single core. Modify the `net.core.rps_sock_flow_entries` parameter to enable RPS.

Enable receive flows steering (RFS): RFS allows the kernel to distribute incoming network traffic to the appropiate process or socket. Modify the `net.core.rps_sock_flow_entries` parameter to enable RFS.

### Optimize firewall and routing rules

Review and optimize firewalls rules: Analyze your firewall rules and ensure they are efficient. Remove any unnecessary rules that might introduce network latency.

Optimize routing tables: Evaluate your routing tables and remove any redundant or inefficient routesd.

### Monitor and continue fine tuning

Use network tools to observe the performance of your system and identify bottlenecks or areas for improvement. Tools like `iftop`, `netstat`, `nethogs` or `iperf` can provice insights