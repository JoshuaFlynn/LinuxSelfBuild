#!/bin/bash
#Version 2.0 LFS edition

#Do a sudo/root level check
uid=$(id -u)

#We don't have root permissions, so we can't install or upgrade anything, so we quit
[ $uid -ne 0 ] && { echo "Only root may run Bash-Apt-Install."; exit 1; }

if (( $# < 1 )); then

    echo "Insufficient number of arguments provided to Bash-Install.sh"
    echo "1. Packname"
    echo "additional packages etc"
    exit 2;
fi

for i in "$@"; do
    #Load package name
    PACKAGE=$i

    #Check for package so we can pull down the blueprint package files
    PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $PACKAGE|grep "install ok installed")

    #It's not there, install and enable it
    if [ "" == "$PKG_OK" ]; then
 	apt-get --force-yes --yes install $PACKAGE
    fi
done

exit 0;
