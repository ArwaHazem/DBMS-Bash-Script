#!/bin/bash

options=("Create Database" "List Databases" "Connect To Databases" "Drop Database" "Exit")

while [ true ];
do
    echo "************************************ Data-Base Menu ************************************"
    for ((i=0; i<${#options[@]}; i++)); do
        echo "$((i+1)). ${options[i]}"
    done
    read -p "Enter Data-Base Operation Number:" option
    case $option in
        1) ./../scripts/db-scripts/db-create.sh
        ;;
        2) ./../scripts/db-scripts/db-list.sh
        ;;
        3) ./../scripts/db-scripts/db-connect.sh
        ;;
        4) ./../scripts/db-scripts/db-drop.sh
        ;;
        5)cd .. ; exit
        ;;
        *) echo "Enter Valid Choice Number"
    esac
done
