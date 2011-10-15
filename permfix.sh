#! /bin/sh

echo Really change perms?
read answer

if [[ "$answer" == "y" ]]
then
    echo Directories to 755
    find . -type d -exec chmod 755 {} \;
    echo Files to 644   
    find . -type f -exec chmod 644 {} \;
    echo Setting scripts to 755
    find . -type f -iname "*.sh" -exec chmod 755 {} \;
else
    echo Exiting
fi
