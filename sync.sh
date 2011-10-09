#! /bin/sh

remote_server="kylefberry.net"
remote_user="kyleb"
local_dir="/srv/http/"
remote_dir="/home/kyleb/public_html"
key_file="/home/k6b/.ssh/id_rsa2"
log_file="/home/k6b/rsync_log"
date=`date +"%m-%d-%y %T"`

echo [$date] >> $log_file
rsync -ave "ssh -i $key_file" $local_dir $remote_user@$remote_server:$remote_dir >> $log_file
