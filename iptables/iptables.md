 
# FIREWALL IPTABLES

To delete all rules in the current table:

    iptables -F

To display the current rules:

    iptables -L -v -n

To set the default policies for the filter table (usually to drop packets by default):
    
    iptables -P INPUT DROP
    iptables -P FORWARD DROP
    iptables -P OUTPUT ACCEPT

To allow incoming SSH traffic on port 22:
    
    iptables -A INPUT -p tcp --dport 22 -j ACCEPT


ICMP is the protocol used by the ping command. To allow ICMP traffic, use:

    iptables -A INPUT -p icmp -j ACCEPT

HTTP and HTTPS traffic uses TCP port 443 and 80. To allow it through the firewall, you would use:

    iptables -A INPUT -p tcp --dport 80 -j ACCEPT    # Allow HTTP traffic
    iptables -A INPUT -p tcp --dport 443 -j ACCEPT   # Allow HTTPS traffic

    iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT    # Allow outgoing HTTP traffic
    iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT   # Allow outgoing HTTPS traffic


To allow DNS traffic through your firewall using iptables, you need to open both UDP and TCP traffic on port 53. The Domain Name System (DNS) primarily uses UDP port 53 for regular queries, but it also uses TCP port 53 for larger queries or zone transfers.

    iptables -A INPUT -p udp --dport 53 -j ACCEPT   # Allow incoming DNS queries (UDP)
    iptables -A INPUT -p tcp --dport 53 -j ACCEPT   # Allow incoming DNS queries (TCP)

    iptables -A OUTPUT -p udp --dport 53 -j ACCEPT  # Allow outgoing DNS queries (UDP)
    iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT  # Allow outgoing DNS queries (TCP)


Allow incoming traffic for established connections:

    iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

Save rules to a file:

    iptables-save > /etc/iptables/rules.v4


