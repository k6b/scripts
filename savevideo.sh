#! /bin/sh

#pid=$(lsof | grep Flash | tail -n 1 | awk '{print $2}')
#fd=$(lsof | grep Flash | tail -n 1 | awk '{print $5}' | sed 's/[a-zA-Z]//')

file=$(lsof | grep Flash | tail -n 1 | awk '{print $2,$5}' | sed 's/[a-zA-Z]//' | awk '{print "/proc/"$1"/fd/"$2}')

cp $file ./$1.flv

#echo "/proc/$pid/fd/$fd"
