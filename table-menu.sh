#!/bin/bash

echo "************************************Table Menu************************************"
PS3="Enter Table Operation Number: "
options=("Create Table" "Drop Table" "Insert into Table" "List Tables" "Select from Table" "Delete from Table" "Update Table" "Return To Databases Menu")
select option in "${options[@]}";
do
    case $REPLY in
        1) 
            echo "Create Table"
	    ;;
        2) 
            echo "Drop Table"
            ;;
        3) 
            echo "Insert into Table" 
            ;;
        4) 
            echo "List Tables"  
            ;;
        5) 
            echo "Select from Table" 
            ;;
        6)
            echo "Delete from Table"
            ;;
        7)
            echo "Update Table"
           ;;
        8)
	    echo "************************************Return To Databases Menu************************************"
  	    cd .. #pwd after cd is supposed to be /DB , prerequisite: cd from connect
            ./../db-menu.sh
            break;;
        *) 
           echo "Invalid Input"
    esac
done
