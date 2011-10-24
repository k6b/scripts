#! /bin/sh

if [ $# -ne 1 ]
then
    echo Usage $(basename $0) scriptname
    exit 1
fi

touch ./$1
chmod 755 ./$1

type=$(echo $1 | awk -F . '{print $2}')

if [[ $type = sh ]]
then
    echo "#! /bin/sh" > $1
    echo "" >> $1
elif [[ $type = pl ]]
then
    echo "#! /usr/bin/perl" > $1
    echo "" >> $1
else
    echo "#!" > $1
    echo "" >> $1
fi

vim ./$1
