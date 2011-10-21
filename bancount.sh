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

ban=$(awk "/\ Ban / "'{ nmatches++ } END { print nmatches }' /var/log/fail2ban.log)
unban=$(awk "/\ Unban / "'{ nmatches++ } END { print nmatches }' /var/log/fail2ban.log)
total=$(($ban - $unban))

if [[ $total -ne "1" ]]
then
    echo -e Currently $total IPs are banned.'\n'
else
    echo -e Currently $total IP is banned.'\n'
fi

if [[ $total -ne "0" ]]
then
    ips=$(iptables -L | awk "/DROP\ /"'{ print $4}' | awk '{ print $1 }')
    echo -e "\033[4mCurrently Banned\033[0m"'\n'
    echo -e "\033[4mIP\t\tDate\t\tTime\033[0m"
        for i in $ips
        do
            if [[ $i =~ [0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3} ]]
            then
                i=$(echo $i | grep -oP "\d{1,3}[-.]\d{1,3}[-.]\d{1,3}[-.]\d{1,3}" | sed 's/-/./g')
            else
                i=$(dig A $i | grep $i | grep -oP "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}")
            fi
            date=$(awk "/Ban\ $i/"'{ print $1 }' /var/log/fail2ban.log)
            time=$(awk "/Ban\ $i/"'{ print $2 }' /var/log/fail2ban.log | cut -d , -f 1)
            echo -e $i'\t'$date'\t'$time
        done
    echo
fi
