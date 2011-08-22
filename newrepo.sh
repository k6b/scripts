#! /bin/sh
# Creates a bare git repo in the current directory
# uses a command line argument to name the repo
# designed for server usage.
if [ $# -ne 3 ]; then #                      
    echo "Usage: $(basename $0) reponame description export(yes/no)"
    exit 1
fi

mkdir ./$1.git                              # Make the new directory
cd ./$1.git
git --bare init                             # Initalize bare repo
echo "[gitweb]" >> config                   # Echo some lines into the config
echo "        Owner = Kyle Berry" >> config # for gitweb
echo $2 > description                       # Set repo description

if [ $3 = "yes" ]; then
    echo "Ok to export to gitweb"
    touch "git-daemon-export-ok"
else
    echo "Not ok to export to gitweb"
fi
cd ..
chown -R git:git ./$1.git
