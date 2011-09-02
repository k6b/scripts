#! /bin/sh
# short script to find the number of IPs banned by fail2ban
touch tmpfile
awk '{if ($6=="Ban") {print $6"\t"$7}}' /var/log/fail2ban.log > tmpfile
bans=$(cat tmpfile | wc -l)
rm tmpfile
echo "$bans IPs have been banned."
