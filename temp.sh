#! /bin/sh
temp=$(acpi -tf | awk '{print $4}')
echo Temp: $temp°
