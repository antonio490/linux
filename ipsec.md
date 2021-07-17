
# IPSec tunnel with strongswan

Strongswan is an open source, cross platform widely used for IPSec based VPN implementation that runs on Linux and many others operating systems. It is a kaying daemon that supports the internet key exchange protocols IKEv1 and IKEv2 to establish security associations between two peers.

Next it will be describe how to set up a site-to-site IPSec VPN gateways using strongSwan on Ubuntu and debian servers.

> Site 1 Gateway

    OS 1: Ubuntu or debian
    Public IP: 10.10.20.1
    Private IP: 192.168.0.101/24
    Private subnet: 192.168.0.0/24

> Site 2 Gateway

    OS 2: Ubuntu or debian
    Public IP: 10.10.20.5
    Private IP: 10.0.2.15/24
    Private subnet: 10.0.2.0/24

- Enable kernel packet forwarding

    $ nano /etc/sysctl.conf

Look for the following lines and uncomment them and set their values as shown (read comments in the file for more information).

    net.ipv4.ip_forward = 1 
    net.ipv6.conf.all.forwarding = 1 
    net.ipv4.conf.all.accept_redirects = 0 
    net.ipv4.conf.all.send_redirects = 0 

Restart and update kernel changes:

    $ sysctl -p

In case there is a firewall blocking traffic, it is mandatory to add some rules:

    $ nano /etc/ufw/before.rules

> SITE 1

    *nat
    :POSTROUTING ACCEPT [0:0]
    -A POSTROUTING -s 10.10.20.0/24  -d 192.168.0.0/24 -j MASQUERADE
    COMMIT

> SITE 2

    *nat
    :POSTROUTING ACCEPT [0:0]
    -A POSTROUTING  -s 192.168.0.0/24 -d 10.0.2.0/24 -j MASQUERADE
    COMMIT

After adding last rules, reboot ufw:

    $ ufw disable

    $ ufw enable

## Install strongswan

    $ apt-get update
    
    $ apt-get install strongswan

After installation check if the service strongswan is running and enable:

    $ sudo systemctl status strongswan.service
    
    $ sudo systemctl is-enabled strongswan.service


## Configure security gateways

Now we need to configure the security gateways on /etc/ipsec.conf

> SITE 1 


    config setup
            charondebug="all"
            uniqueids=yes
    conn devgateway-to-prodgateway
            type=tunnel
            auto=start
            keyexchange=ikev2
            authby=secret
            left=10.20.20.1
            leftsubnet=192.168.0.101/24
            right=10.20.20.3
            rightsubnet=10.0.2.15/24
            ike=aes256-sha1-modp1024!
            esp=aes256-sha1!
            aggressive=no
            keyingtries=%forever
            ikelifetime=28800s
            lifetime=3600s
            dpddelay=30s
            dpdtimeout=120s
            dpdaction=restart


> SITE 2

    config setup
            charondebug="all"
            uniqueids=yes
    conn prodgateway-to-devgateway
            type=tunnel
            auto=start
            keyexchange=ikev2
            authby=secret
            left=10.20.20.5
            leftsubnet=10.0.2.15/24
            right=10.20.20.1
            rightsubnet=192.168.0.101/24 
            ike=aes256-sha1-modp1024!
            esp=aes256-sha1!
            aggressive=no
            keyingtries=%forever
            ikelifetime=28800s
            lifetime=3600s
            dpddelay=30s
            dpdtimeout=120s
            dpdaction=restart

- left – defines the IP address of the left participant’s public-network interface (local).
- leftsubnet – states the private subnet behind the left participant.
- right – specifies the IP address of the right participant’s public-network interface (remote).
- rightsubnet – states the private subnet behind the left participant.

## Configure PSK for peer identification

Letś generate a secure PSK:

    $ head -c 24 /dev/urandom | base64

Next, add the PSK in the /etc/ipsec.secrets file on both gateways.

    ------- Site 1 Gateway ------- 

    10.20.20.1 10.20.20.5 : PSK "qLGLTVQOfqvGLsWP75FEtLGtwN3Hu0ku6C5HItKo6ac="

    ------- Site 2 Gateway -------

    10.20.20.5  10.20.20.1 : PSK "qLGLTVQOfqvGLsWP75FEtLGtwN3Hu0ku6C5HItKo6ac="

<br>

    $ sudo ipsec restart

    $ sudo ipsec status