#!/bin/sh

# Network interface for internet access
DEV='eth0'

# Subnet value
PRIVATE=10.8.0.0/24

# If DEV is not specified, automatically detect the default gateway interface
if [ -z "$DEV" ]; then
    DEV="$(ip route | grep default | head -n 1 | awk '{print $5}')"
fi

# Enable transit IP packet routing
sysctl net.ipv4.ip_forward=1

# Check for iptables forwarding rule
iptables -I FORWARD -j ACCEPT

# Network Address Translation (NAT)
iptables -t nat -I POSTROUTING -s $PRIVATE -o $DEV -j MASQUERADE

