
     ____                 _                            ____  _ 
    |  _ \ __ _ ___ _ __ | |__   ___ _ __ _ __ _   _  |  _ \(_)
    | |_) / _` / __| '_ \| '_ \ / _ \ '__| '__| | | | | |_) | |
    |  _ < (_| \__ \ |_) | |_) |  __/ |  | |  | |_| | |  __/| |
    |_| \_\__,_|___/ .__/|_.__/ \___|_|  |_|   \__, | |_|   |_|
                   |_|                         |___/           


> version 3


### Configurations


On boot partition create a file wap_supplicant.conf to start wifi on startup and and another file ssh empy to enable and start ssh server.

<code>

    country=ES
    ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
    update_config=1

    network={
            ssid=<SSID>
            scan_ssid=1
            psk=<password>
            key_mgmt=WPA-PSK
            id_str="home"
    }
</code>

Otherwise we can configure network interfaces like this after boot.

> /etc/network/interfaces

<code>
    auto lo
    iface lo inet loopback

    auto eth0
    iface eth0 inet static
        address 172.22.17.X
        netmask 255.255.255.0

    auto wlan0
    iface wlan0 inet dhcp
        wpa-ssid <NAME-SSID>
        wpa-psk  <PASS-PSK>


</code>

Miscellaneous configurations

<code>

     # raspi-config

</code>

1. Enable SSH server startup
2. Enbale I2C and Camera interfaces
3. Set localisation options