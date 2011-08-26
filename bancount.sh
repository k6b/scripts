#! /bin/sh
# short script to find the number of IPs banned by fail2ban
touch tmpfile
awk '{print $6"\t"$7}' /var/log/fail2ban.log > tmpfile
bans=$(cat tmpfile | grep Ban | wc -l)
rm tmpfile
echo "$bans IPs have been banned."
