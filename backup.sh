#! /bin/sh
#Thanks Spuh!
echo $(date) >> /var/log/backup.log

for i in $(grep ^backups /etc/group |cut -d: -f 4- |sed s/,/\ /g)
do
    grep $i /etc/passwd | awk -F : '{print $6}'
    tar zcf /backup/backup.$(date +%m.%d.%y).$i.tar.gz $(grep $i /etc/passwd | awk -F : '{print $6}')
    chown $i:$i /backup/backup.$(date +%m.%d.%y).$i.tar.gz  
done
sites=$(ls /srv | sed 's/gitosis//g')
for j in $sites
do
    tar zcf /backup/backup.$(date +%m.%d.%y).$j.tar.gz /srv/$j
done

find /backup -type f -iname "backup*" -mtime +3 -exec s3cmd -p put {} s3://k6b-backups/ \;
find /backup -type f -iname "backup*" -mtime +3 -delete
