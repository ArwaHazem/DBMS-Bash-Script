#! /usr/bin/bash
export LC_COLLATE=C
shopt -s extglob

if [[ "$(basename "$PWD")" == "DB" ]]; 
then
     if [[ -z $(ls -d */ 2> /dev/null | cut -f1 -d'/' ) ]]
    then
        echo -e "\nNo Database exist\n"
    else
        ls -d */ | cut -f1 -d'/'
    fi
    ./../db-menu.sh
    
else 
    echo "Invalid Path"    
fi
