#!/bin/bash


choices=("Create Table" "Drop Table" "Insert into Table" "List Tables" "Select from Table" "Delete from Table" "Update Table" "Return To Databases Menu")

while [ true ];
do
    echo "************************************Table Menu************************************"
    for ((i=0; i<${#choices[@]}; i++)); do
        echo "$((i+1)). ${choices[i]}"
    done
    read -p "Enter Table Operation Number: " choice
    case $choice in
        1) 
            ./../../scripts/table-scripts/table-create.sh
	    ;;
        2) 
            ./../../scripts/table-scripts/table-drop.sh
            ;;
        3) 
            echo "Insert into Table" 
            ;;
        4) 
            ./../../scripts/table-scripts/table-list.sh
            ;;
        5) 
            ./../../scripts/table-scripts/table-select.sh
            ;;
        6)
            echo "Delete from Table"
            ;;
        7)
            echo "Update Table"
           ;;
        8)
  	    cd .. #pwd after cd is supposed to be /DB , prerequisite: cd from connect
            exit
            ;;
        *) 
           echo "Invalid Input"
    esac
done
