#!/bin/bash
#Version 1.1

#Do a sudo/root level check
uid=$(id -u)

[ $uid -ne 0 ] && { echo "Root is required to run the base build package installer."; exit 1; }

if (( $# != 1 )); then

    echo "Insufficient number of arguments provided to Format-Partion.sh"
    echo "1. /dev/ drive ID to format"
    exit 2;
fi

#Setup username (for home directory referencing)
_user=$(logname)

#run our first update
apt-get update

#Point to our target directory
_TAR_DIR="/home/$_user/LinuxSelfBuild/Base/"

#Ensure all the utilities we need are installed
bash "$_TAR_DIR/HelperScripts/Bash-Apt-Install.sh" fdisk grep

#Get the target drive name
_TARGET_DRIVE=$1

#Acquire target drive data specs
_DRIVE_DATA=fdisk -l "/dev/$_TARGET_DRIVE" | grep "Disk" | grep "byte"

echo "$_DRIVE_DATA"