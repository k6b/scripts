#!/bin/bash

file=""
action="$1"
user="$2"
passwd="$3"
file="$4"

case $action in
	add)
		grep -q $user $file
		if [ "$?" -eq "0" ]
		then
			echo "Found user: $user in file: $file, aborting..."
		else
			echo "Didn't find user: $user in file: $file"
			password=$(perl -le "print crypt($passwd, 'salt-hash')")
			echo "$user:$password" >> $file
			echo "Added user: $user with password: $password to file: $file"
		fi
	;;
	del)
		file=$passwd
		grep -q $user $file
		if [ "$?" -eq "0" ]; then
			echo "Found user: $user in $file"
			sed -si /$user/d $file
			echo "Removed user: $user from file: $file"
		else
			echo "Didn't find user: $user in file: $file"
		fi
	;;
	list)
		file=$user
		echo -e "Listing: $file (username:password)\n"
		cat $file
		echo
	;;
	*)
		echo -e "\nauthpwd - by k6b\nUsage:\n"
		echo -e "$(basename $0) {add|del|list}:" 
		echo -e "\tadd:"
		echo -e "\t\t$(basename $0) username password authfile"
		echo -e "\tdel:"
		echo -e "\t\t$(basename $0) username password authfile"
		echo -e "\tlist:"
		echo -e "\t\t$(basename $0) authfile"
	;;
esac
