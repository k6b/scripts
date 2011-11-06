#! /bin/sh
# k6b

bigone=25

if [ "$1" -lt "$bigone" ]
then
   echo Get ready! Pulling $1 times!!
   sleep 2
else
    echo This is gonna be a BIG ONE!
    sleep 2
    echo Pulling $1 times!!!
    sleep 1
fi

for (( i=1; i<=$1; i++ ))
do
    echo \.pull
done
