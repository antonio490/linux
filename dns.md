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

## Record types