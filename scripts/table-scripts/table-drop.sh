#!/bin/bash

export LC_COLLATE=C
shopt -s extglob

source ./../../scripts/utilities.sh

dbname=$(basename "$PWD")
# tableList=$(find_valid_tables "$PWD")


drop_table() {
        ./../../scripts/table-scripts/table-list.sh
        read -p "Please Enter Table Name You want to drop : " tableName
        if validate_name "$tableName" ; then

            if [[ -f "$tableName" && -f ".$tableName-metadata" ]]; then

                valid_input=false
                echo "Are you sure you want to drop $tableName table? (y/n)"
                while ! $valid_input; do
                    read -r option
                    case $option in
                        [Yy] ) 
                            # will remove table and meta data of table
                            rm "$tableName" ; rm ".$tableName-metadata"
                            echo "$tableName table has been dropped"
                            valid_input=true
                            ;;
                        [Nn] ) 
                            echo "---Drop operation is Canceled---"
                            valid_input=true
                            ;;
                        * ) 
                            echo "---Invalid Input. Please enter 'y' or 'n'"
                            ;;
                    esac
                done
            else
                echo "---$tableName table does not exist---"
            fi
        else
            echo "---Invalid table name---"
        fi
    
}

drop_table