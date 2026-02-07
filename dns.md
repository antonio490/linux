# DNS

## What it is?

It translates domain names to IP addresses.

## Hierarchy

This is the backbone of how dns works. DNS has a tree structure where each level has its own responsability downward.

```shell
.
└── Root
    ├── .com
    │   ├── google.com
    │   │   ├── www.google.com
    │   │   └── mail.google.com
    │   └── example.com
    └── .org
        └── wikipedia.org
            └── en.wikipedia.org

```

#### Root Zone (.)

At the very top, there is the root zone (represented by a dot .).

It doesn’t have a name itself, but it points to where to find the Top-Level Domain (TLD) servers.

Managed by ICANN/IANA and operated by 12 organizations worldwide.

There are 13 logical root server addresses (A to M), but in reality thousands of servers use Anycast to provide them.

- Example:
When you look up www.example.com, your DNS resolver first checks the root for “Who knows .com?”

#### Top-Level Domains (TLDs)

These are the endings like .com, .org, .net, .edu, .gov, plus all the country codes (.uk, .de, .in, etc.) and new gTLDs (.app, .dev, .xyz).

Each TLD has its own authoritative name servers, managed by a registry (e.g., Verisign manages .com).

- Example:
The .com TLD servers know which nameservers are authoritative for example.com.

#### Second-Level Domains (SLDs)

This is usually what you register from a registrar.

Example: example.com — the example part is the second-level domain, under .com.

The owner of the SLD controls its DNS settings (A, MX, CNAME records, etc.).

- Example:
The .com servers tell you “Go ask these authoritative servers for example.com.”

#### Subdomains

Anything under your domain is a subdomain.

Example: www.example.com, mail.example.com, blog.example.com.

You (the domain owner) can create as many as you like by adding records to your zone file.

Subdomains can even delegate authority further — e.g., sales.example.com could have its own DNS servers.

#### Hostnames

At the very bottom are individual hostnames mapped to IPs.

Example: www.example.com → 93.184.216.34.

These are usually A (IPv4) or AAAA (IPv6) records.

#### How a Lookup Travels the Hierarchy

Say your computer wants to resolve www.wikipedia.org:

Ask the Root Servers: “Where are .org servers?”
→ Root replies with list of .org TLD servers.

Ask the .com TLD Servers: “Where is wikipedia.org authoritative server?”
→ They reply with the NS (nameservers) for wikipedia.org.

Ask the example.com Nameserver: “What’s the IP for www.wikipedia.org?”
→ It replies with the A/AAAA record.

Answer returned to you (and cached by resolvers for faster future queries).

```
Key insight: The hierarchy is all about delegation.
Each level doesn’t know everything, it just knows who’s responsible next.
```

### Example with dig command

```bash
$ dig www.wikipedia.org

    ; <<>> DiG 9.18.39-0ubuntu0.24.04.1-Ubuntu <<>> www.wikipedia.org
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 57693
    ;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1

    ;; OPT PSEUDOSECTION:
    ; EDNS: version: 0, flags:; udp: 65494
    ;; QUESTION SECTION:
    ;www.wikipedia.org.		IN	A

    ;; ANSWER SECTION:
    www.wikipedia.org.	33913	IN	CNAME	dyna.wikimedia.org.
    dyna.wikimedia.org.	178	IN	A	185.15.59.224

    ;; Query time: 13 msec
    ;; SERVER: 127.0.0.53#53(127.0.0.53) (UDP)
    ;; WHEN: Fri Sep 12 20:11:33 CEST 2025
    ;; MSG SIZE  rcvd: 91

```



## Record types

#### A (Address Record)
Maps a domain name → IPv4 address.
Most common record type.

```bash
Example: example.com.   3600   IN   A   93.184.216.34
```
→ example.com points to IPv4 93.184.216.34.

#### AAAA (Quad-A Record)
Same as A, but for IPv6.

```bash
Example: example.com.   3600   IN   AAAA   2606:2800:220:1:248:1893:25c8:1946
```

#### CNAME (Canonical Name)
Makes one domain an alias of another.
Always points to another hostname, not an IP.

```bash
Example: www.example.com.   3600   IN   CNAME   example.com.
```
→ www.example.com resolves to the same IP as example.com.

- Rules: A domain with a CNAME can’t have other records (like MX, A) at the same level. CNAME chains add lookup overhead.


#### MX (Mail Exchange)
Tells mail servers where to deliver email.
Has priority (lower number = higher priority).

Example: 
```bash
example.com.   3600   IN   MX   10 mail1.example.com.
example.com.   3600   IN   MX   20 mail2.example.com.
```

#### PTR (Pointer)

Used for reverse DNS lookup (IP → domain).

Example:
```bash
IP 93.184.216.34 might resolve to example.com.
```
Important for email servers (anti-spam checks).


#### DNS LOC Record

The LOC (Location) record is used to specify geographical location information for a domain name, including latitude, longitude, altitude, size, and precision.
- It was defined in RFC 1876

| Record    | Purpose                          |
| --------- | -------------------------------- |
| **A**     | Domain → IPv4                    |
| **AAAA**  | Domain → IPv6                    |
| **CNAME** | Alias to another domain          |
| **MX**    | Mail server for a domain         |
| **TXT**   | Text (SPF, DKIM, verification)   |
| **PTR**   | Reverse lookup (IP → domain)     |
| **NS**    | Authoritative nameservers        |
| **SOA**   | Zone information (admin, timers) |
| **SRV**   | Service discovery (host + port)  |
| **CAA**   | Control SSL cert issuance        |
| **NAPTR** | Advanced service discovery       |
| **LOC**   | Location record                  |


## DNS Protocol Basics

#### Transport:

- Uses UDP (port 53) for most queries (faster, less overhead).
- Uses TCP (port 53) for:
  - Responses larger than 512 bytes (without EDNS0).
  - Zone transfers between nameservers (AXFR/IXFR).
  - DNSSEC (because signatures can be large).
  - Newer extensions like DoT (DNS over TLS) and DoH (DNS over HTTPS) run over 853/443.
- Message format: DNS messages are structured the same for queries and responses.


## Installation of BIND in linux


First of all I have created a VM using qemu-img.

# create bridge virbr0 in the Host
```bash
sudo ip link add name virbr0 type bridge
sudo ip link set virbr0 up

# create tap and attach to bridge
sudo ip tuntap add tap0 mode tap
sudo ip link set tap0 master virbr0
sudo ip link set tap0 up

```

# run VM
```bash
qemu-system-x86_64 \
  -enable-kvm \
  -m 4G \
  -hda dns.qcow2 \
  -netdev tap,id=mynet0,ifname=tap0,script=no,downscript=no \
  -device virtio-net-pci,netdev=mynet0

```


### Configuring zones in NSD

Example of a configure zone for NSD:

  $ORIGIN lab.ans.es.
  $TTL 86400
  
  @    IN     SOA    dns1.lab.ans.es.     admin.lab.ans.es    (
       1;     Serial
       86400; Refresh
       7200;  Retry
       57600; Expire
       3600);  Negative TTL

  @    IN     NS    dns1.lab.ans.es.     
  @    IN     NS    dns2.lab.ans.es.
  
  dns1.lab.ans.es    IN    A    10.0.222.103
  dns2.lab.ans.es    IN    A    10.0.222.104   


Add this into the configuration file /etc/nsd/nsd.conf to recognize your zone created:

  zone:
      name: "lab.ans.es"
      zonefile: "lab.ans.es.dns"

when modifying a zone is important not to restart the service but instead refresh the individual zone, so there is not service interruption.First lets check configuration and zone is correct with these two cli tools:

  $ nsd-checkconf /etc/nsd/nsd.conf

  $ nsd-checkzone lab.ans.es /etc/nsd/lab.ans.es.dns

  $ nsd-control reconfig

Let's check now if a dns lookup works:

  $ dig @10.0.222.103 dns2.lab.ans.es

NSD doesn't provide reversive lookup, for that we need to configure a different service name BOUND. 