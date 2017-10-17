#!/bin/bash
#Version 1.0

[ $uid -ne 0 ] && { echo "Root is required to run the base build package installer."; exit 1; }

#installpkg
#removepkg

#SlackWare

installpkg bash
installpkg binutils
installpkg bison
installpkg bzip2
installpkg coreutils
installpkg diffutils
installpkg findutils
installpkg gawk
installpkg gcc
installpkg g++
installpkg glibc
installpkg grep
installpkg gzip
installpkg m4
installpkg make
installpkg patch
installpkg perl
installpkg sed
installpkg tar
installpkg texinfo
installpkg xz-utils

TARGET_DIR="./HelperScripts"

#Debian

bash "$TARGET_DIR/Bash-Apt-Install.sh" bash binutils bison bzip2 coreutils diffutils findutils gawk gcc g++ glibc grep gzip m4 make patch perl sed tar texinfo xz-utils

