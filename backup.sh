#! /bin/sh
#Thanks Spuh!
echo $(date) >> /var/log/backup_log
find /backup -type f -iname "backup*" -mtime +14 -exec rm {} \;
for i in $(grep ^backups /etc/group |cut -d: -f 4- |sed s/,/\ /g)
do
    grep $i /etc/passwd | awk -F : '{print $6}'
    tar zcf /backup/backup.$(date +%m.%d.%y).$i.tar.gz $(grep $i /etc/passwd | awk -F : '{print $6}')
    chown $i:$i /backup/backup.$(date +%m.%d.%y).$i.tar.gz  
done
