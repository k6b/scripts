#! /bin/sh
# backup - by k6b - 2.4.12
# Creates backups and moves them over via ftp

# Define some variables:

ftpuser=""
ftppass="" 
ftphost=""
loglocation="backup.log"
tmpdir="$(mktemp -d)"
ugroup="$i"
dbback=""
sqlpw=""

# Get a list of the databases on the machine

databases=$(mysql -u root --password=$sqlpw -e 'show databases' | cut -d'|' -f2 | sed '/information_schema/d' | sed '/Database/d')

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

mkdir -p $tmpdir/backup/$dbback/$time

# use the list of databases that we made
# eariler to make MySQL backups of our
# databases

for k in $databases
do
	echo dumping database $k
	nice -n19 mysqldump -u root --password=$sqlpw $k | gzip > $tmpdir/backup/$dbback/$time/$k.$(date +%m.%d.%y).sql.gz
done

list () {
	case $1 in
		user)
			/bin/ls -l $tmpdir/backup/$time | awk '{print $9}'
			;;
		mysql)
			/bin/ls -l $tmpdir/backup/$dbback/$time | awk '{print $9}'
			;;
	esac
	}

for i in $(list user)
do
	curl -s -T $tmpdir/backup/$time/$i ftp://$ftpuser:$ftppass@$ftphost/$time/
done

for j in $(list mysql)
do
	curl -s -T $tmpdir/backup/$dbback/$time/$j ftp://$ftpuser:$ftppass@$ftphost/$dbback/$time/
done

rm -rf $tmpdir/backup
