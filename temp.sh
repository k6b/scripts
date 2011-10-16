#! /bin/sh
temp=$(cat /sys/class/thermal/thermal_zone0/temp)
tempc=$(echo " scale=1 ; ( $temp / 1000 ) " | bc )
tempf=$(echo " scale=1 ; ( ( 9 / 5 ) * $tempc ) + 32" | bc )
echo Temp: $tempf°
