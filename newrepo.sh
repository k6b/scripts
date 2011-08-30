#! /bin/sh
# Creates a bare git repo in the current directory
# uses a command line argument to name the repo
# designed for server usage.
#
if [[ $EUID -ne 0 ]]; then
    echo "Must be run as root!!"
    exit 
fi
if [ "$1" == "--help" ]; then
    echo ""
    echo "          newrepo by Kyle Berry(k6b)             "
    echo "                  (C) 2011"
    echo "newrepo, creates bare git repos on the server with"
    echo "a given name, and description and allows you to   "
    echo "decide if you want the repo exported to gitweb. "
    echo ""
    echo "Usage: $(basename $0) reponame description export"
    echo ""
    echo "reponame:    single string, please omit .git"
    echo "description: a description of the repo for gitweb"
    echo "             you need to quote things longer than"
    echo "             one word"
    echo "export:      yes to export to gitweb, no to keep"
    echo "             private"
    echo ""
    echo "  --help     display this help and exit"
    echo ""
    exit
else 
if  [ $# -ne 3 ]; then                       # Echo usage if run empty
    echo "newrepo: missing operand"
    echo "Try  $(basename $0) --help for more information."
    exit
fi
fi
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
