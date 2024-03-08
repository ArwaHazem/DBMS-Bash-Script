#!/bin/bash

export LC_COLLATE=C
shopt -s extglob

validate_name() {
    local string="$1"
    local regex="^[a-zA-Z][_0-9a-zA-Z]{,63}$"

    if [[ $string =~ $regex ]]; then
        return 0  # Matches
    else
        return 1  # Doesn't match
    fi
}

check_permission() {
    local user="$1"   
    local file="$2"    
    local permission="$3" 

    local file_owner=$(stat -c "%U" "$file")
    local file_group=$(stat -c "%G" "$file")

    local owner_permissions=$(stat -c "%A" "$file" | cut -c 2-4)
    local group_permissions=$(stat -c "%A" "$file" | cut -c 5-7)
    local others_permissions=$(stat -c "%A" "$file" | cut -c 8-10)

    if [ "$user" == "$file_owner" ]; then
        if [[ "$owner_permissions" == *"$permission"* ]]; then
            return 0
        else
            return 1
        fi
    fi

    if groups "$user" | grep -q "$file_group"; then
        if [[ "$group_permissions" == *"$permission"* ]]; then
            return 0
        else
            return 1
        fi
    fi

    if [[ "$others_permissions" == *"$permission"* ]]; then
        return 0
    else
        return 1
    fi
}


find_valid_tables() {
    local directory="$1"  
    local filesList=$(find . -maxdepth 1 -type f -not -name ".*" | cut -f2 -d'/')
    local tableList=()

    for file in $filesList; do
        if [[ -f "$directory/.$file-metadata" ]]; then
            tableList+=("$file")
        fi
    done
    echo "${tableList[@]}"
}

: <<'COMMENT'
import script to use utilities function
example of usage in your file:
if validate_name "$var" ; then
    echo "String matches the pattern"
else
    echo "String does not match the pattern"
fi
COMMENT




