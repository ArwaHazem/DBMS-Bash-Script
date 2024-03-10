#! /usr/bin/bash
export LC_COLLATE=C
shopt -s extglob
source ./../../scripts/utilities.sh

tableList=$(list_valid_tables "$PWD")

function list_tables() {
    if [[ -z "$tableList" ]]; then
        echo "------No Tables exist in \"$(basename "$PWD")\" DataBase ------" 
    else
        typeset -i tableNumber=1
        echo  "***********Table List*************"
        for table in $tableList; do
            echo "$tableNumber- $table"
            ((tableNumber++))
        done
   
    fi
}

list_tables