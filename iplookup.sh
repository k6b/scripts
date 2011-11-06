#! /bin/sh

if [[ $1 =~ [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3} ]]
then
    country=$(geoiplookup $1 | cut -d , -f 2 | sed 's/\ //')
    echo $country
else
    ip=$(host $1 | awk '{print $LF}')
    country=$(geoiplookup $ip | cut -d , -f 2 | sed 's/\ //')
    echo $country
fi

