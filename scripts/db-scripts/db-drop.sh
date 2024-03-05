#!/bin/bash

export LC_COLLATE=C
shopt -s extglob


#pwd supposed to be /DB
drop_database() {


    echo "******************Available DataBases********************"
    # List all directories in one column
    if [ "$(ls -d */ 2>/dev/null)" ]; then
        ls -d1 */ # List databases
        read -p "Please Enter DataBase Name: " dbname
        if [[ -d ./$dbname ]]; then
            valid_input=false
            echo "Are you sure ou want to drop $dbname database? (y/n)"
            while ! $valid_input; do
                read -r option
                case $option in
                    [Yy] ) 
                        rm -r "$dbname"
                        echo "$dbname database has been dropped"
                        valid_input=true
                        ;;
                    [Nn] ) 
                        echo "Drop operation is Canceled"
                        valid_input=true
                        ;;
                    * ) 
                        echo "Invalid Input. Please enter 'y' or 'n'"
                        ;;
                esac
            done
        else
            echo "$dbname does not exist"
        fi
    else
        echo "No databases created yet."
    fi

    ./../db-menu.sh

}

drop_database