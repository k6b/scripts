#! /bin/sh

echo Is the screen correct?
read answer

if [[ "$answer" == "n" ]]
then
    echo Fixing
    #xrandr shit
else
    echo Have a nice day :\)
fi
