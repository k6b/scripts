#! /bin/sh
# Creates a bare git repo in the current directory
# uses a command line argument to name the repo
# designed for server usage.
if [ $# -ne 1 ]; then #                      
    echo Usage: $(basename $0) reponame
    exit 1
fi

mkdir ./$1.git                              # Make the new directory
cd ./$1.git
git --bare init                             # Initalize bare repo
echo "[gitweb]" >> config                   # Echo some lines into the config
echo "        Owner = Kyle Berry" >> config # for gitweb
