#! /bin/sh


awk "/\ Ban [0-9]++.[0-9]++.[0-9]++.[0-9]++/"'{print $1,$2}' /var/log/fail2ban.log | cut -d , -f 1 > ./$1 


chown k6b:k6b ./$1
