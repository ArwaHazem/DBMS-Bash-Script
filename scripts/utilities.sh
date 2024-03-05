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

: <<'COMMENT'
import script to use utilities function
example of usage in your file:
if validate_name "$var" ; then
    echo "String matches the pattern"
else
    echo "String does not match the pattern"
fi
COMMENT




