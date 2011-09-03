#! /bin/sh
# short script to find the number of IPs banned by fail2ban
awk "/\ Ban / "'{ nmatches++ }
    END { print nmatches, "IPs have been banned." }' /var/log/fail2ban.log
awk "/Ban [0-9]++.[0-9]++.[0-9]++.[0-9]++/"'{ a[$7]++ }
    { for ( i in a ) { if ( a[i]-1 ) print i, a[i] }}' /var/log/fail2ban.log |
awk 'END { if ($2>1) { print $1" has been banned "$2" times." }}'
