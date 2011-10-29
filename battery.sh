#! /bin/sh

battery=$(acpi | awk '{print $4,$3,$5}' | sed s/,//g)

echo $battery
