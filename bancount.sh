#! /bin/sh
# short script to find the number of IPs banned by fail2ban
if [[ $EUID -ne 0 ]]; then
    echo Must be run as root!
    exit 0
fi
echo
awk "/\ Ban / "'{ nmatches++ }
    END { print nmatches, "IPs have been banned." }' /var/log/fail2ban.log
echo -e '\n'"\033[4m\033[1mIP\t\tBans\033[0m"
awk "/Ban [0-9]++.[0-9]++.[0-9]++.[0-9]++/"'{ a[$7]++ } 
    { for ( i in a ) { if ( a[i]-1 ) print i, a[i] }}' /var/log/fail2ban.log | 
awk '{a[$1]<$NF?a[$1]=$NF:""} END {for (i in a){print i,"\t"a[i]}}'
echo 
