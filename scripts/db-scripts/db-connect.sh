#!/bin/bash

export LC_COLLATE=C
shopt -s extglob

source ./../scripts/utilities.sh

connect_to_database() {

    echo -e "\e[33m******************Available DataBases********************\e[0m"
    # List all directories in one column
    if [ "$(ls -d */ 2>/dev/null)" ]; then
        ls -d */ | cut -f1 -d'/' # List databases
        read -p "Please Enter DataBase Name: " dbname
        
        # Check if dbname matches the regex pattern
        if validate_name "$dbname" ; then
            if [[ -d "./$dbname" ]]; then
                echo -e "\e[32mConnecting to $dbname ... \e[0m"
                clear
                cd "$dbname"
                ./../../table-menu.sh
            else
                clear
                echo -e "\e[31m$dbname does not exist\e[0m"
            fi
        else
            clear
            echo -e "\e[31m---Invalid database name----\e[0m"
        fi
    else
        clear
        echo -e "\e[31m---No databases created yet to connect to---\e[0m"
    fi

    
}

connect_to_database
