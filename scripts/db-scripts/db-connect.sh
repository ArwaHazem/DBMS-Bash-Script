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
                cd "$dbname"
                ./../../table-menu.sh
                db_exists=true 
            else
                echo "$dbname does not exist"
            fi
        else
            echo "Invalid database name"
        fi
    else
        echo "No databases created yet to connect to"
    fi

    # if [ "$db_exists" = false ]; then
    #     # then pwd is /DB/
    #     ./../db-menu.sh
    # fi
}

connect_to_database 