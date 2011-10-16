#! /bin/sh
#Thanks Spuh!
find /backup -type f -iname "backup*" -mtime +14 -exec rm {} \;
for i in $(grep ^backups /etc/group |cut -d: -f 4- |sed s/,/\ /g)
do
    grep $i /etc/passwd | awk -F : '{print $6}'
    tar zcvf /backup/backup.$(date +%m.%d.%y).$i.tar.gz $(grep $i /etc/passwd | awk -F : '{print $6}')
    chown $i:$i backup.`date +%m.%d.%y`.$i.tar.gz  
done
