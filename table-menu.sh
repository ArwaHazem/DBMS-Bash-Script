#!/bin/bash


choices=("Create Table" "Drop Table" "Insert into Table" "List Tables" "Select from Table" "Delete from Table" "Update Table" "Return To Databases Menu")

while [ true ];
do
    echo -e "\e[33m************************************Table Menu************************************\e[0m"
    for ((i=0; i<${#choices[@]}; i++)); do
       echo -e "\e[33m$((i+1)). ${choices[i]}\e[0m"
    done
    read -p "Enter Table Operation Number: " choice
    case $choice in
        1)  clear
            ./../../scripts/table-scripts/table-create.sh
	    ;;
        2)  clear
            ./../../scripts/table-scripts/table-drop.sh
        ;;

        3)  clear
            ./../../scripts/table-scripts/table-insert.sh 
        ;;
        4)  clear
            ./../../scripts/table-scripts/table-list.sh
        ;;
        5)  clear
            ./../../scripts/table-scripts/table-select.sh
        ;;
        6)  clear
            ./../../scripts/table-scripts/table-delete.sh
        ;;
        7)  clear
            ./../../scripts/table-scripts/table-update.sh
        ;;
        8)
  	    cd .. #pwd after cd is supposed to be /DB , prerequisite: cd from connect
            break;;
        *) 
           echo "Invalid Input"
    esac
done
