#! /bin/sh
# short script to find the number of IPs banned by fail2ban
touch tmpfile
awk '{print $1"\t"$6"\t"$7}' /var/log/fail2ban.log > tmpfile
sed 's/Fail2Ban//g' tmpfile -i
bans=$(cat tmpfile | grep Ban | wc -l)
rm tmpfile
echo "$bans IPs have been banned."
