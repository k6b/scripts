#! /bin/sh
# short script to find the number of IPs banned by fail2ban
# by k6b kyle@kyleberry.org

if [[ $EUID -ne 0 ]]; then
    echo Must be run as root!
    exit 0
fi

echo -e '\n'"\033[4m\033[1mFail2Ban\033[0m"'\n'

awk "/\ Ban / "'{ nmatches++ }
    END { print nmatches, "IPs have been banned." }' /var/log/fail2ban.log

echo -e '\n'"\033[4mIP\t\tBans\tCountry\033[0m"

iplist=$(awk "/Ban [0-9]++.[0-9]++.[0-9]++.[0-9]++/"'{ a[$7]++ } 
    { for ( i in a ) { if ( a[i]-1 ) print i, a[i] }}' /var/log/fail2ban.log | 
awk '{ a[$1] < $NF? a[$1] = $NF : "" } END { for ( i in a ) { print i, "\t" a[i] }}' |
awk '{print $1}') 

for i in $iplist
do
ip=$(awk "/Ban\ $i/"'{ a[$7]++ } 
    { for ( i in a ) { if ( a[i]-1 ) print i, a[i] }}' /var/log/fail2ban.log | 
awk '{ a[$1] < $NF? a[$1] = $NF : "" } END { for ( i in a ) { print i, "\t" a[i] }}' |
awk '{print $1}')

bantime=$(awk "/Ban\ $i/"'{ a[$7]++ } 
    { for ( i in a ) { if ( a[i]-1 ) print i, a[i] }}' /var/log/fail2ban.log | 
awk '{ a[$1] < $NF? a[$1] = $NF : "" } END { for ( i in a ) { print i, "\t" a[i] }}' |
awk '{print $2}')

echo -e $ip'\t'$bantime'\t'$(geoiplookup $i | awk -F , '{print $2}' | sed s/\ //)
done

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
    ips=$(egrep "\ Ban\ " /var/log/fail2ban.log | tail -n $total | awk '{print $7}')
    echo -e "\033[4mCurrently Banned\033[0m"'\n'
    echo -e "\033[4mIP\t\tDate\t\tTime\t\tCountry\033[0m"
        for i in $ips
        do
            date=$(awk "/Ban\ $i/"'{ print $1 }' /var/log/fail2ban.log | tail -n $total)
            time=$(awk "/Ban\ $i/"'{ print $2 }' /var/log/fail2ban.log | cut -d , -f 1 | tail -n $total)
            echo -e $i'\t'$date'\t'$time'\t'$(geoiplookup $i | awk -F , '{print $2}' | sed s/\ //)
        done
    echo
fi
