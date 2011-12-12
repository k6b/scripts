#! /bin/sh
# Creates backups and moves them over via ftp
# I'm using ncftp because I found an example 
# passing input to it, and it seemed easier
# than figuring out how to do it with regular ftp
# so fuckit, I'll probably change it later.

# Define some variables:

ftpuser=""
ftppass="" 
ftphost=""
webroot=""
loglocation="backup.log"
tmpdir="/dev/shm"
ugroup="$i"
dbback="mysql"

# Get a list of the databases on the machine
# currently, exclude the 'Databases' title and
# the 'information_schema' database

databases=$(mysql -e 'show databases' | cut -d'|' -f2 | sed '/information_schema/d' | sed '/Database/d')

# Echo information to $loglocation
# Uncomment this if you aren't directing cron
# output to /dev/null I plan to add some more
# detailed logging later

#echo $(date) >> /var/log/$loglocation

# Create a list of domains to backup. They should
# be in seperate folders in your $webroot

sites=$(ls /home/public_html | sed 's/\///g')

# Decide what folder name to use for backup location
# based on $1

case $1 in
	w)
		time='weekly'
		;;
	d)
		time='daily'
		;;
	m)
		time='monthly'
		;;
	*)
		echo Usage: $basename $0 "{d,w,m}"
		echo d - daily
		echo w - weekly
		echo m - monthly
		exit 0
esac

# Create a temporary directory using $tempdir

mkdir -p $tmpdir/backup/$time

# See who's a member of the backups group

for i in $(grep "^backup" /etc/group |cut -d: -f 4- |sed s/,/\ /g)
do
	# Echo for log output

	echo compressing user $i

	# Compress the users home directory using 
	# gzip. Set CPU priority low to save some stress.

	nice -n19 tar cfpPz $tmpdir/backup/$time/$i.$(date +%m.%d.%y).tar.gz $(grep $i /etc/passwd | awk -F : '{print $6}' | sed 's/\/$//g')
done

# Use list of sites to backup domains

for j in $sites
do
	# Echo for log output

	echo compressing domain $j
	
	# Compress using gzip like before

	nice -n19 tar cfpPz $tmpdir/backup/$time/$j.$(date +%m.%d.%y).tar.gz $webroot/$j
done

mkdir -p $tmpdir/backup/$dbback/$time

# use the list of databases that we made
# eariler to make MySQL backups of our
# databases

for k in $databases
do
	echo dumping database $k
	nice -n19 mysqldump $k > $tmpdir/backup/$dbback/$time/$k.$(date +%m.%d.%y).sql
done

# Open ncftp to transfer files to our
# FTP backup. Fill out the variables above
# with your information.

ncftp << EOF
open -u $ftpuser -p $ftppass $ftphost
cd /$time
lcd $tmpdir/backup/$time
put *
cd /$dbback/$time
lcd $tmpdir/backup/$dbback/$time
put *
bye
EOF

# Remove our temp file. I hope it was nothing 
# you wanted to keep, like resolv.conf.

rm -rf $tmpdir/backup

# Profit?
