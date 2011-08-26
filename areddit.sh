#! /bin/bash

karma=$(curl --connect-timeout 1 -fsm 3 http://www.reddit.com/user/4wd22r/about.json | awk '{match($0, "k_karma\": ([0-9]+)", a); match($0, "t_karma\": ([0-9]+)", b); print "Link karma:", a[1], "Comment karma:", b[1];}')
echo "redditwidget.text = '$karma'" | awesome-client