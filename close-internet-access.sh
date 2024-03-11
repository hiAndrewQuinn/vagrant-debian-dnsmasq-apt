#!/bin/bash

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root" >&2
  exit 1
fi

# Allow loopback access
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allow SSH to the internet_server (adjust IP accordingly)
iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT

# Block all other outbound traffic
iptables -P OUTPUT DROP

# Save the iptables rule
iptables-save >/etc/iptables/rules.v4

exit 0
