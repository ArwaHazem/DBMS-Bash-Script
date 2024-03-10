#!/bin/bash

export LC_COLLATE=C
shopt -s extglob

source ./../../scripts/utilities.sh

dbname=$(basename "$PWD")
tableList=$(list_valid_tables "$PWD")

drop_table() {
    ./../../scripts/table-scripts/table-list.sh
    if [[ ! -z "$tableList" ]]; then
        read -p "Please Enter Table Name You want to drop : " tableName
        if validate_name "$tableName" ; then

            if [[ -f "$tableName" && -f ".$tableName-metadata" ]]; then

                valid_input=false
           echo -e "\e[34mAre you sure you want to drop $tableName table? (y/n)\e[0m"
                while ! $valid_input; do
                    read -r option
                    case $option in
                        [Yy] ) 
                            # will remove table and meta data of table
                            rm "$tableName" ; rm ".$tableName-metadata"
                            echo -e "\e[32m$tableName table has been dropped\e[0m"
                            valid_input=true
                            ;;
                        [Nn] ) 
                            echo -e "\e[31m---Drop operation is Canceled---\e[0m"
                            valid_input=true
                            ;;
                        * ) 
                            echo -e "\e[31m---Invalid Input. Please enter 'y' or 'n'\e[0m"
                            ;;
                    esac
                done
            else
                echo -e "\e[31m---$tableName table does not exist---\e[0m"
            fi
        else
            echo -e "\e[31m---Invalid table name---\e[0m"
        fi
    fi
}

drop_table