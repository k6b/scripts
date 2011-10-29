#! /bin/sh
temp=$(cat /sys/class/thermal/thermal_zone0/temp)
tempc=$(echo " scale=1 ; ( $temp / 1000 ) " | bc )
tempf=$(echo " scale=1 ; ( ( 9 / 5 ) * $tempc ) + 32" | bc )
if [[ $tempf < 130 ]]
then
    echo -e "Temp: \e[32m$tempf°\e[0m"
elif [[ $tempf > 150 ]]
then
    echo -e "Temp: \e[31m$tempf°\e[0m"
else
    echo -e "Temp: \e[33m$tempf°\e[0m"
fi
