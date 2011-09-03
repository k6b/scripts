#! /bin/sh
# short script to find the number of IPs banned by fail2ban
awk "/\ Ban / "'{ nmatches++ }
    END { print nmatches, "IPs have been banned." }' /var/log/fail2ban.log
