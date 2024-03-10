#! /usr/bin/bash
export LC_COLLATE=C
shopt -s extglob

function list_databases() {
    if [[ "$(basename "$PWD")" == "DB" ]]; 
    then
        if [[ -z "$(ls -d */ 2> /dev/null)" ]]
            then
                echo -e "\e[31m---No Database exist---\n\e[0m"
        else
            echo -e "\e[33m***********Database List*************\e[0m"
            ls -d */ | cut -f1 -d'/'
        fi
    
else 
    echo -e "\e[31m---Invalid Path---\e[0m"    
fi

}
list_databases
