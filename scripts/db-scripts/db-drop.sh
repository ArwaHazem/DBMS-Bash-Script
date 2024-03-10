#!/bin/bash

export LC_COLLATE=C
shopt -s extglob


#pwd supposed to be /DB

source ./../scripts/utilities.sh


drop_database() {


   echo -e "\e[33m******************Available DataBases********************\e[0m"
    # List all directories in one column
    if [ "$(ls -d */ 2>/dev/null)" ]; then
        ls -d */ | cut -f1 -d'/' # List databases
        read -p "Please Enter DataBase Name: " dbname
        if validate_name "$dbname" ; then
            if [[ -d "./$dbname" ]]; then
                valid_input=false
                echo -e "\e[34mAre you sure you want to drop $dbname database? (y/n)\e[0m"
                while ! $valid_input; do
                    read -r option
                    case $option in
                        [Yy] ) 
                            rm -r "$dbname"
                            echo -e "\e[32m$dbname database has been dropped\e[0m"
                            valid_input=true
                            ;;
                        [Nn] ) 
                            echo -e "\e[31m---Drop operation is Canceled---\e[0m"
                            valid_input=true
                            ;;
                        * ) 
                            echo -e "\e[31m---Invalid database name---\e[0m"
                            ;;
                    esac
                done
            else
                echo -e "\e[31m$dbname database doesn't exist\e[0m"
            fi
        else
            echo -e "\e[31m---Invalid database name---\e[0m"
        fi
    else
        echo -e "\e[31m---No databases created yet---\e[0m"
    fi

    # ./../db-menu.sh

}

drop_database