#! /bin/sh
# short script to find the number of IPs banned by fail2ban
if [[ $EUID -ne 0 ]]; then
    echo Must be run as root!
    exit 0
fi
echo -e '\n'"\033[4m\033[1mFail2Ban\033[0m"'\n'
awk "/\ Ban / "'{ nmatches++ }
    END { print nmatches, "IPs have been banned." }' /var/log/fail2ban.log
echo -e '\n'"\033[4mIP\t\tBans\033[0m"
awk "/Ban [0-9]++.[0-9]++.[0-9]++.[0-9]++/"'{ a[$7]++ } 
    { for ( i in a ) { if ( a[i]-1 ) print i, a[i] }}' /var/log/fail2ban.log | 
awk '{ a[$1] < $NF? a[$1] = $NF : "" } END { for ( i in a ) { print i, "\t" a[i] }}'
echo
ban=`awk "/\ Ban / "'{ nmatches++ } END { print nmatches }' /var/log/fail2ban.log`
unban=`awk "/\ Unban / "'{ nmatches++ } END { print nmatches }' /var/log/fail2ban.log`
total=$(($ban - $unban))
if [[ $total -ne "1" ]]; then
    echo Currently $total IPs are banned.
else
    echo Currently $total IP is banned.
fi
echo
