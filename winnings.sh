#! /bin/sh

money=$(grep -i "congratulations $1" \#austinreddit.log | awk '{print $6}' | sed -e 's/,\|\$//g' | cut -d . -f 1)

cash=$((echo $money | sed 's/\ /\ +\ /g') | bc)

echo -e You have won: \$$cash
