#! /bin/sh

battery=$(acpi | awk '{print $4,$3,$5}' | sed s/,//g)

percent=$(echo $battery | awk '{print $1}' | sed 's/%//')
state=$(echo $battery | awk '{print $2}')
time=$(echo $battery | awk '{print $3}')

if [[ $percent -gt "66" ]]
then
    echo -e "Batt: \e[32m$percent%\e[0m $state $time"
elif [[ $percent < "33" ]]
then
    echo -e "Batt: \e[31m$percent%\e[0m $state $time"
else
    echo -e "Batt: \e[33m$percent%\e[0m $state $time"
fi
