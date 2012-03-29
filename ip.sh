#!/bin/bash
# returns our external ip address 
# and if we are using a vpn.
#
# 3/6/12 - k6b@0x2a.co

myip=`curl -s icanhazip.com`
tun=`ip a | grep -o tun | uniq`

if [[ "$tun" != "tun" ]]
then
	echo "local: $myip"
else
	echo "  VPN: $myip"
fi
