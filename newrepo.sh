#! /bin/sh
if [ $# -ne 1]; then #
    echo Usage: $(basename $0) Repo name, no .git
    exit
fi

mkdir ./$1.git
cd ./$1.git
git --bare init
echo "[gitweb]" >> config
echo "      Owner = Kyle Berry" >> config
