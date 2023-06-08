
     ____                 _                            ____  _ 
    |  _ \ __ _ ___ _ __ | |__   ___ _ __ _ __ _   _  |  _ \(_)
    | |_) / _` / __| '_ \| '_ \ / _ \ '__| '__| | | | | |_) | |
    |  _ < (_| \__ \ |_) | |_) |  __/ |  | |  | |_| | |  __/| |
    |_| \_\__,_|___/ .__/|_.__/ \___|_|  |_|   \__, | |_|   |_|
                   |_|                         |___/           


> version 3


### Configurations


On boot partition create a file wap_supplicant.conf to start wifi on startup and and another file ssh empy to enable and start ssh server.


```js
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
```

Otherwise we can configure network interfaces like this after boot. `/etc/network/interfaces`

```js
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

```


```js
# raspi-config
```

1. Enable SSH server startup
2. Enable I2C and Camera interfaces
3. Set localization options


## Services

### Node-Red

Installation script:

```js
$ bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered)
```

To launch node red service locally execute this command:

```js
$ node-red-pi --max-old-space-size=256
```

If you want Node-RED to run when the Pi is turned on, or re-booted, you can enable the service to autostart by running the command:

```js
# systemctl enable nodered.service
```

To disable the service, run the command:

```js
# systemctl disable nodered.service
```

When browsing from another machine you should use the hostname or IP-address of the Pi: <kbd> http://<hostname>:1880 </kbd> You can find the IP address by running hostname -I on the Pi.

### MQTT

```js
# apt-get update
# apt-get install mosquitto
# apt-get install mosquitto-clients
```

#### Demo

```js
pi@raspberrypi:~ $ mosquitto_sub -d -h localhost -t "TEST"
```

```js
antonio ~ $ mosquitto_pub -h 172.22.17.100 -t "TEST" -m "Mi primer mensaje usando MQTT"


Client mosqsub|3788-raspberryp received PUBLISH (d0, q0, r0, m0, 'GPIO', ... (29 bytes))
Mi primer mensaje usando MQTT
```