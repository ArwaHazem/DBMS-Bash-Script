#!/bin/bash
echo "************************************ Data-Base Menu ************************************"
PS3="Enter Data-Base Operation Number: "
select choice in "Create Database" "List Databases" "Connect To Databases" "Drop Database" "Exit"
do
    case $REPLY in
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
