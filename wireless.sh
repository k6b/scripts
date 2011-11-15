#!/bin/sh

essid=$(iwconfig wlan0 | awk -F '"' '/ESSID/ {print $2}')
stngth=$(iwconfig wlan0 | awk -F '=' '/Quality/ {print $2}' | cut -d '/' -f 1)
bars=$(expr $stngth / 7)

case $bars in
  1) bar='{/---------}' ;;
  2) bar='{\\--------}' ;;
  3) bar='{///-------}' ;;
  4) bar='{\\\\------}' ;;
  5) bar='{/////-----}' ;;
  6) bar='{\\\\\\----}' ;;
  7) bar='{///////---}' ;;
  8) bar='{\\\\\\\\--}' ;;
  9) bar='{/////////-}' ;;
 10) bar='{\\\\\\\\\\}' ;;
  *) bar='{----!!----}' ;;
esac

echo $essid $bar

exit 0
