#! /bin/sh


awk "/\ Ban [0-9]++.[0-9]++.[0-9]++.[0-9]++/"'{print $1,$2}' /var/log/fail2ban.log | cut -d , -f 1 > ./.tmp 

awk '{print $2,$1}' ./.tmp > ./$1

chown k6b:k6b ./$1
