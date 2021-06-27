
# NMAP

### Network mapper utility for network discovery and network auditing.

<br>

#### Examples

<br>

> scan tcp ports.

    $ nmap -sN 192.168.1.0/24


> scan udp ports.

    $ nmap -sU 192.168.1.0/24


> scan ip address with T4 timing level.

    $ nmap -T4 -A 192.168.1.122

> scan intensively on ports 80 and 53.

    $ nmap -T4 -A -p 80,53 192.168.1.122

#### Scripts

<br>

On the next directory we can useful scripts:

    $ ls /usr/share/nmap/scripts

Run a script using next command:

    $ nmap -p 443 --script=<name> 192.168.1.122
    