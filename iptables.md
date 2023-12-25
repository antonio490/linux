
# Linux iptables


### Iptables, Rules, Targets and Policies

```bash
# To flush all chains, which will delete all of the firewall rules, you may use the -F , or the equivalent --flush
$ iptables --flush
```

```bash
# add rule "LOG every packet" to chain INPUT
$ iptables --append INPUT --jump LOG

# add rule "DROP every packet" to chain INPUT
$ iptables --append INPUT --jump DROP
```


```bash
# block packets with source IP 46.36.222.157
# -A is a shortcut for --append
# -j is a shortcut for --jump
$ iptables -A INPUT -s 46.36.222.157 -j DROP

# block outgoing SSH connections
$ iptables -A OUTPUT -p tcp --dport 22 -j DROP

# allow all incoming HTTP(S) connections
$ iptables -A INPUT -p tcp -m multiport --dports 80,443 \
  -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
$ iptables -A OUTPUT -p tcp -m multiport --dports 80,443 \
  -m conntrack --ctstate ESTABLISHED -j ACCEPT
```

```bash
root@xps-ubuntu:~# iptables -S
-P INPUT ACCEPT
-P FORWARD ACCEPT
-P OUTPUT ACCEPT
-N DOCKER
-N DOCKER-ISOLATION-STAGE-1
-N DOCKER-ISOLATION-STAGE-2
-N DOCKER-USER
-A FORWARD -j DOCKER-USER
-A FORWARD -j DOCKER-ISOLATION-STAGE-1
-A FORWARD -o docker0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A FORWARD -o docker0 -j DOCKER
-A FORWARD -i docker0 ! -o docker0 -j ACCEPT
-A FORWARD -i docker0 -o docker0 -j ACCEPT
-A OUTPUT -p tcp -m tcp --dport 22 -j DROP
-A DOCKER-ISOLATION-STAGE-1 -i docker0 ! -o docker0 -j DOCKER-ISOLATION-STAGE-2
-A DOCKER-ISOLATION-STAGE-1 -j RETURN
-A DOCKER-ISOLATION-STAGE-2 -o docker0 -j DROP
-A DOCKER-ISOLATION-STAGE-2 -j RETURN
-A DOCKER-USER -j RETURN
```