#!/bin/bash

export LC_COLLATE=C
shopt -s extglob

source ./../../scripts/utilities.sh

dbname=$(basename "$PWD")

function deleteAll(){
    if [ -s "$tableName" ]; then
        echo -n > "$tableName"
        if [ ! -s "$tableName" ]; then
            echo -e "\e[31m---\"$tableName\" table deleted successfully---\e[0m"
        else
            echo -e "\e[31m---Error in delete \"$tableName\"---\e[0m"
        fi
    else
        echo -e "\e[31m---Table is empty---\e[0m"
    fi
}

function deleteByRecord(){
    if [ -s "$tableName" ]; then
        awk -F ":" '{print NR"-" $1}' ".$tableName-metadata"
        columnsNum=$(wc -l < ".$tableName-metadata")
        rowsNumBefore=$(wc -l < "$tableName")

        read -p "Enter Column Number: " columnNumber
        if [[ $columnNumber =~ ^[1-9][0-9]*$ ]]; then
            if ((columnNumber < 1 || columnNumber > columnsNum))
            then
                echo -e "\e[31m---Invalid Column Number---\e[0m"
            else
                #logic is here
                read -p "Enter Value: " fieldValue

                matchedRecords=$(awk -F : -v colNum="$columnNumber" -v value="$fieldValue" '$colNum == value {print $0}' "$tableName")

                if [[ -z "$matchedRecords" ]]; then
                    echo -e "\e[31m---No Matched Records Founded To Delete---\e[0m"
                else
                    touch "$tableName-temp"
                    awk -F: -v fValue=$fieldValue fNum=$columnNumber'{if($fNum!=fValue)print $0}' "$tableName" > "$tableName-temp"
                    cat "$tableName-temp" > "$tableName"
                    rm -f "$tableName-temp"
                    #check if the records no longer exist
                    matchedRecords=$(awk -F : -v colNum="$columnNumber" -v value="$fieldValue" '$colNum == value {print $0}' "$tableName")
                    if [[ -z "$matchedRecords" ]]; then
                        rowsNumAfter=$(wc -l < "$tableName")
                        deletedRecords=$((rowsNumBefore - rowsNumAfter))
                        echo -e "\e[32m$deletedRecords record(s) deleted successfully\e[0m"
                    else
                        echo -e "\e[31m---Error in deleting---\e[0m"
                    fi
                fi
            fi
        else
            echo -e "\e[31m---Invalid Input---\e[0m"
        fi
    else
        echo -e "\e[31m---Table is empty---\e[0m"
    fi
}

function delete_table_menu(){
    ./../../scripts/table-scripts/table-list.sh
    read -p "Please Enter Table Name You want to select from : " tableName
    if validate_name "$tableName" ; then
        if [[ -f "$tableName" && -f ".$tableName-metadata" ]]; then
            choices=("Delete All Records" "Delete Record By value" "Exist")
            while true ; do
                echo -e "\e[33m--------------Delete Menu---------------\e[0m"
                for ((i=0; i<${#choices[@]}; i++)); do
                    echo -e "\e[33m$((i+1)). ${choices[i]}\e[0m"
                done

                read -p "Enter Delete Operation Number: " choice
                case $choice in
                    1)
                        deleteAll
                    ;;
                    2)
                        deleteByRecord
                    ;;
                    3)  clear
                        break
                    ;;
                    *)
                        echo -e "\e[31m---Invalid Input---\e[0m"
                esac
            done
        else
            echo -e "\e[31m$tableName table does not exist\e[0m"
        fi
    else
        echo -e "\e[31m---Invalid Table Name---\e[0m"
    fi
}

delete_table_menu
