#!/bin/bash

export LC_COLLATE=C
shopt -s extglob

source ./../scripts/utilities.sh

connect_to_database() {
    db_exists=false 

    echo "******************Available DataBases********************"
    # List all directories in one column
    if [ "$(ls -d */ 2>/dev/null)" ]; then
        ls -d1 */ # List databases
        read -p "Please Enter DataBase Name: " dbname
        
        # Check if dbname matches the regex pattern
        if validate_name "$dbname" ; then
            if [[ -d "./$dbname" ]]; then
                echo "Connecting to $dbname ... "
                clear
                cd "$dbname"
                ./../../table-menu.sh
                db_exists=true 
            else
                clear
                echo "$dbname does not exist"
            fi
        else
            clear
            echo "Invalid database name"
        fi
    else
        clear
        echo "No databases created yet to connect to"
    fi

    
}

connect_to_database 