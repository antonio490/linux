
## Strongswan

Strongswan is a complete IPsec solution providing encryption and authentication to servers and clients. It can be used to secure communications with remote networks, so that connecting remotely is the same as connecting locally.

Gateway: the gateway is usually your firewall, but this can be any host within your network. Often the gateway is also able to serve a small network with DHCP and DNS.

Host-to-Host: This can be a remote web server or a backup system. T

Site-to-Site: Hosts in two ir more subnets at different locations should be able to access each other.

Strongswan is a keying daemon which uses the Internet Key Exchange protocols (IKEv1 and IKEv2) to establish security associations (SA) between two peers. IKE provides strong authentication of both peers and derives unique cryptographic session keys. Such an IKE session is often denoted IKE_SA on strongswan. Besides authentication and kez material IKE also provides the means to exchange configuration information and to negotiate IPsec SAs, which are often called CHILD_SAs. IPsec SAs define which network traffic is to be secured and how it has to be encrypted and authenticated.

