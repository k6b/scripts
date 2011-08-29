#! /bin/bash

user=4wd22r
sleep_sec=900
count=0
while :; do
    let count=$count+1
    karma=$(curl --connect-timeout 1 -fsm 3 http://www.reddit.com/user/$user/about.json | awk '{match($0, "k_karma\": ([0-9]+)", a); match($0, "t_karma\": ([0-9]+)", b); print "L:", a[1], "C:", b[1];}')
    echo "redditwidget.text = '$karma'" | awesome-client
    sleep $sleep_sec
done
