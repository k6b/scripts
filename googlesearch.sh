#! /bin/sh
term="test"
sleep_sec=7200
count=0
while :; do
    let count=$count+1
    wget -U "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7) Gecko/20040613 Firefox/0.8.0+" "http://www.google.com/search?q=$term"
    rm search\?q=$term
    sleep $sleep_sec
done
