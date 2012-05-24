#!/bin/bash
# returns our external ip address 
# and if we are using a vpn.
#
# 3/6/12 - k6b@0x2a.co

myip=`curl -s icanhazip.com`
tcun=`ip a | grep -o tun | uniq`

if [[ "$myip" == "" ]]
then
	myip="###.##.##.###"
fi

if [[ "$tun" != "tun" ]]
then
	echo "<fc=red>-(</fc>$myip<fc=red>)-</fc>"
else
	echo "<fc=green>-(</fc>$myip<fc=green>)-</fc>"
fi
