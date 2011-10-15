#! /bin/sh

echo Really change perms?
read answer

if [[ "$answer" == "y" ]]
then
    echo -e Directories to 755'\n'
    find . -type d -exec chmod 755 {} \;
    echo -e Files to 644'\n'
    find . -type f -exec chmod 644 {} \;
    echo -e Setting scripts to 755'\n'
    find . -type f -iname "*.sh" -exec chmod 755 {} \;
else
    echo Exiting
fi
