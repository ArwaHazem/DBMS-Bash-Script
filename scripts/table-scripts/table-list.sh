#! /usr/bin/bash
export LC_COLLATE=C
shopt -s extglob
source ./../../scripts/utilities.sh

tableList=$(list_valid_tables "$PWD")

function list_tables() {
    if [[ -z "$tableList" ]]; then
        echo -e "\e[31m------No Tables exist in \"$(basename "$PWD")\" DataBase ------\e[0m"
    else
        typeset -i tableNumber=1
        echo -e "\e[33m***********Table List*************\e[0m"
        for table in $tableList; do
            echo -e "$tableNumber- $table"
            ((tableNumber++))
        done
   
    fi
}

list_tables