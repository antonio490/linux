## TCP perfomance with sysctl

With sysctl is possible to configure kernel parameters:

- Device parameters         
- Network parameters
- Firewall parameters   
- File system
- NFS
- Processes

List of all parameters:

<code> sysctl -a </code>


| Layer | Type of data |
|:---------------:|----------|
| Transport Layer | Segments |
| Network Layer   | Packets  |
| Data Link Layer | Frames   |

### Bandwidth delay product BDP

\begin{align}
BDP = BW /times RTT
\end{align}

If the receiver window is less than the BDP then the connection is wasting resources.

Brandwidth delay product will go on increasing if the latency RTT is higher.

Open systeclt.conf and modify this values:

    tcp_window.scaling = 1
    net.core.rmem_max = 16777216 (1Gbi)
    net.core.wmem_max = 16777216 (1Gbi)
    net.ipv4.tcp_rmem = 4096    87580   16777216
    net.ipv4.tcp_wmem = 4096    8750    16777216

<code> sysctl -p /etc/sysctl.conf </code>
