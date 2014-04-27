#!/bin/bash
# @author tom@0x101.com
echo '1.Initializing security rules'

# Reset the rules
iptables -F
iptables -X

echo '2.Removing previous rules'

#############################################
# Default policies
# Reject all the connections
#############################################
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

echo '3.Default rules initialized'

#############################################
# Customized rules
#############################################

# loopback interface
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -j ACCEPT

echo 'Loopback interface'

# Allow packages associated with pre-existing connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# SSH client
iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# WEB clients
iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT

iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Response to ping sin ping-flooding
iptables -A INPUT -p icmp -m limit --limit 1/s --limit-burst 10 -j ACCEPT

# ping commands
iptables -A OUTPUT -p icmp -j ACCEPT

echo 'Rules applied'
