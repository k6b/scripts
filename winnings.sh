#! /bin/sh

money=$(grep -i "congratulations $1" ~/irclogs/FreeNode/\#austinreddit.log | awk '{print $6}' | sed -e 's/,\|\$//g' | cut -d . -f 1 | grep -e [0-9])

cash=$((echo $money | sed 's/\ /\ +\ /g') | bc)

if [[ $cash < 1 ]]
then
    echo $1 has won NOTHING!
else
    echo -e $1 has won: \$$cash
fi
