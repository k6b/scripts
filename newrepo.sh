#! /bin/sh
# Creates a bare git repo in the current directory
# uses a command line argument to name the repo
# designed for server usage.
if [ UUID = 0 ]; then
if [ $# -ne 3 ]; then                       # Echo usage if run empty
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
    touch "git-daemon-export-ok"            # Allow gitweb if yes
else
    echo "Not ok to export to gitweb"       # No gitweb if no
fi
cd ..                                       # Go back one dir
chown -R git:git ./$1.git                   # Change ownership to git
else
    echo "must run as root"
    exit 1
