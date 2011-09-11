#! /bin/sh
# creates new remote tracking branch
if [ $# -ne 1 ]; then
    echo Usage: $(basename $0) newbranchname
    exit 1
fi
git push origin origin:refs/heads/$1
git fetch origin
git checkout --track -b $1 origin/$1
git pull
