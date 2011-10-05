#! /bin/sh

#name=$(awk "/post_id:/"'{print $2}' $1 | awk 'BEGIN { FS = "/" } { print $5 }')
name=$RANDOM
date=$(date +"%m-%d-%Y") 
sed '0,/From:/d' $1 > /home/k6b/jekyll/_comments/$date-$name
