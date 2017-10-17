#!/bin/bash
#Version 2.0 LFS edition

if (( $# < 2 )); then

    echo 'Arguments required:'
    echo '1. Source directory to recursively pass over'
    echo '2. Destination directory to recursively copy to'
    echo '3. (Optional) directory that this script itself is located in (used for handling relative recursion issues).'
    echo '4. (Optional) print characters prior to directory and filename display (used for visual formatting)'
    exit 1;

fi

SOURCE_DIR=$1
TARGET_DIR=$2

#See if an optional third argument has been provided (IE the script directory)
if (( $# < 3 )); then

    #If not, get it
    #This extracts the absolute directory of the script
    pushd $( dirname "$0"  ) > /dev/null
    SCRIPT_DIR=$( pwd -P )
    popd > /dev/null

else

    #If so, check it and set it
    if [ -d "$3" ]; then

        SCRIPT_DIR=$3

    else

        echo "Supplied script directory is not actually a directory: $3"
        exit 2;

    fi

fi

#See if any print chars for readability have been supplied, if not, set it to defaults
if (( $# > 3 )); then

    PRINT_CHARS=$4

else

    PRINT_CHARS=""

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
        bash "$FULL_SCRIPT" "$SOURCE_DIR/$f" "$TARGET_DIR/$f" "$SCRIPT_DIR" "$PRINT_CHARS    "

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