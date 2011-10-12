#! /bin/sh
# short script to find the number of IPs banned by fail2ban
echo -e '\n'
awk "/\ Ban / "'{ nmatches++ }
    END { print nmatches, "IPs have been banned." }' /var/log/fail2ban.log
echo -e '\n'IP'\t\t'Bans
awk "/Ban [0-9]++.[0-9]++.[0-9]++.[0-9]++/"'{ a[$7]++ } 
    { for ( i in a ) { if ( a[i]-1 ) print i, a[i] }}' /var/log/fail2ban.log | 
awk '! a[$0]++' | 
awk '{a[$1]<$NF?a[$1]=$NF:""} END {for (i in a){print i,"\t"a[i]}}'
echo -e '\n'
