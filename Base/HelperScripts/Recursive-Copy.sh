#!/bin/bash
#Version 2.0 LFS edition
#Updated to use export

if (( $# != 2 )); then

    echo 'Arguments required:'
    echo '1. Source directory to recursively pass over'
    echo '2. Destination directory to recursively copy to'
    exit 1;

fi

SOURCE_DIR=$1
TARGET_DIR=$2

#See if the script directory variable is already set:
if [ -z "$SCRIPT_DIR" ]; then

    #If not, get it
    #This extracts the absolute directory of the script
    pushd $( dirname "$0"  ) > /dev/null
    export SCRIPT_DIR=$( pwd -P )
    popd > /dev/null

fi

if [ -z "$PRINT_CHARS" ]; then

    export PRINT_CHARS="    "

else

    export PRINT_CHARS="$PRINT_CHARS    "

fi

#Extract the script's basename minus the directory
SCRIPT_NAME=$( basename "$0" )

#Merge the script directory with the script name
FULL_SCRIPT="$SCRIPT_DIR/$SCRIPT_NAME"

cd "$SOURCE_DIR"

RED='\033[0;31m'
GREEN='\033[1;32m'
NO_COLOUR='\033[0m'
ON_BLACK='\033[40m' 

#Make the sub target directory if it doesn't exist (we use the parents flag just in-case this is the start of a copy over)
if mkdir -p "$TARGET_DIR"
then
    #echo -e "[${ON_BLACK}${GREEN}OK${NO_COLOUR}]"
    :
else
    echo -e "[${ON_BLACK}${RED}FAIL${NO_COLOUR}] (status code: $?)"
    exit 3;
fi


for f in *; do

    #Check if it's a directory
    if [ -d "$f" ]; then
        
        echo "$PRINT_CHARS/$f"
        #Rerun this script again, passing the directory
        bash "$FULL_SCRIPT" "$SOURCE_DIR/$f" "$TARGET_DIR/$f"

    elif [ -f "$f" ]
    then

        
        echo -n "$PRINT_CHARS"
        if cp -u "$SOURCE_DIR/$f" "$TARGET_DIR/$f" 
        then
            echo -en "[${ON_BLACK}${GREEN}OK${NO_COLOUR}]"
        else
            echo -en "[${ON_BLACK}${RED}FAIL${NO_COLOUR}] (status code: $?)"
        fi
        echo " $f"

    else
    
        echo "$f is unrecognised as either a directory or a file"

    fi

done

exit 0;