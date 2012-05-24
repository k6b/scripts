#!/bin/sh

sec=0
essid=$(iwconfig wlan0 | awk -F '"' '/ESSID/ {print $2}')
stngth=$(iwconfig wlan0 | awk -F '=' '/Quality/ {print $2}' | cut -d '/' -f 1)
bars=$(expr $stngth / 7)
sec=$(iwlist wlan0 scan | awk 'tolower($0) ~/wpa|wep/ {print $0}')

case $bars in
  1) bar='<fc=red>#</fc>:::::::::' ;;
  2) bar='<fc=red>##</fc>::::::::' ;;
  3) bar='<fc=red>###</fc>:::::::' ;;
  4) bar='<fc=yellow>####</fc>::::::' ;;
  5) bar='<fc=yellow>#####</fc>:::::' ;;
  6) bar='<fc=yellow>######</fc>::::' ;;
  7) bar='<fc=green>#######</fc>:::' ;;
  8) bar='<fc=green>########</fc>::' ;;
  9) bar='<fc=green>#########</fc>:' ;;
 10) bar='<fc=green>##########</fc>' ;;
  *) bar='<fc=red>.:!:..:!:.</fc>' ;;
esac

if [[ "$sec" == "" ]]
then
	echo "<fc=red>-(</fc>$essid<fc=red>)-</fc> $bar"
else
	echo "<fc=green>-(</fc>$essid<fc=green>)-</fc> $bar"
fi

exit 0
