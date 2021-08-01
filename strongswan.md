
## Strongswan

Strongswan is a complete IPsec solution providing encryption and authentication to servers and clients. It can be used to secure communications with remote networks, so that connecting remotely is the same as connecting locally.

Gateway: the gateway is usually your firewall, but this can be any host within your network. Often the gateway is also able to serve a small network with DHCP and DNS.

Host-to-Host: This can be a remote web server or a backup system. T

Site-to-Site: Hosts in two ir more subnets at different locations should be able to access each other.

Strongswan is a keying daemon which uses the Internet Key Exchange protocols (IKEv1 and IKEv2) to establish security associations (SA) between two peers. IKE provides strong authentication of both peers and derives unique cryptographic session keys. Such an IKE session is often denoted IKE_SA on strongswan. Besides authentication and kez material IKE also provides the means to exchange configuration information and to negotiate IPsec SAs, which are often called CHILD_SAs. IPsec SAs define which network traffic is to be secured and how it has to be encrypted and authenticated.


### Authentication

To ensure that the peer with which an IKE_SA is established is reallz it claims to be it has to be authenticated.

Methods:

- Public Key Authentication

- Pre-Shared-Key (PSK)

- Extensible Authentication Protocol (EAP)

### Configuration files

The recommended way of configuring strongswan is with swanctl command line tool. The swanctl.conf configuration file is used by swanctl is stored together with certificated and corresponding private keys in the swanctl directory.
Alternatevely, the legacy ipsec stroke interface and its ipsec.conf and ipsec.secrets configuration files may be used.


### Init

Strongswan is usually managed with the swanctl command, while the IKE daemon charon is controlled by the systemd on modern distros.With legacy installations, strongswan is controlled by the ipsec command, where ipsec start will start the starter daemon which in turn starts and configures the keying daemon charon.

- On traffic: If start_action=trap/auto=route is used, IPsec trap policies for the configured traffic (local|remote_ts/left|rightsubnet) will be installed and traffic matching these policies will trigger acquire events that cause the daemon to establish the required IKE/IPsec SAs.

- On startup: CHILD_SAs configured with start_action=start or (auto=start) will automatically be established when the daemon is started. The are not automatically restarted when they go down for some reason. You need to specify other configuration settings. (dpd_action/dpdaction and/or close_action/closeaction) to restart them automatically, but even then, the setup is not bullet-proof and will potentially leak packets.

- Manually: A connection that uses no start_action (or auto=add in ipsec.conf) has to be established manually with swanctl --initiate or ipsec up. Depending on the configuration, it is also possible to use swanctl --install or ipsec route to install policies manually for such connections, like start_action=trap/auto=route would do it on startup.