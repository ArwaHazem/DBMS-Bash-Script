#!/bin/bash

export LC_COLLATE=C
shopt -s extglob

source ./../../scripts/utilities.sh

dbname=$(basename "$PWD")
tableList=$(list_valid_tables "$PWD")


function selectAll() {
    if [ -s "$tableName" ]; then
        echo -e "\e[33m---------------------------\"$tableName table\" records-------------------------\e[0m"
        awk -F':' '{printf "%s | ", $1}' ".$tableName-metadata"

        echo -e "\n\e[33m----------------------values-----------------\e[0m"
        sed 's/:/ | /g' "$tableName"
    else
        echo -e "\e[31m---Table is empty----\e[0m"
    fi
}


function selectByColumn {
    if [ -s "$tableName" ]; then
        awk -F ":" '{print NR"-" $1 }' ".$tableName-metadata"
        columnsNum=$(wc -l < ".$tableName-metadata")

        read -p "Enter Column Number: " columnNumber
        if [[ $columnNumber =~ ^[1-9][0-9]*$ ]]
        then
            columnName=$(awk -F ':' -v columnNum="$columnNumber" 'NR == columnNum {print $1}' ".$tableName-metadata")
            if ((columnNumber < 1 || columnNumber > columnsNum))
            then
                echo -e "\e[31m---Invalid Column Number---\e[0m"
            else
                echo -e "\e[33m-----------------Column \"$columnName\" data-------------\e[0m"
                awk -F : -v colNum="$columnNumber" '{print $colNum;}' "$tableName"
            fi
        else
            echo -e "\e[31m---Invalid Input---\e[0m"
        fi  
    else
        echo -e "\e[31m---Table is empty---\e[0m"
    fi
}

function selectByRecord() {
    if [ -s "$tableName" ]; then
        awk -F ":" '{print NR"-" $1 }' ".$tableName-metadata"
        columnsNum=$(wc -l < ".$tableName-metadata")

        read -p "Enter Column Number: " columnNumber
        if [[ $columnNumber =~ ^[1-9][0-9]*$ ]]
        then
            if ((columnNumber < 1 || columnNumber > columnsNum))
            then
                echo -e "\e[31m---Invalid Column Number---\e[0m"
            else
                #Logic is here 
                read -p "Enter Value: " recordValue 
    
                matchedRecords=$(awk -F : -v colNum="$columnNumber" -v value="$recordValue" '$colNum == value {print $0}' "$tableName")

                if [[ -z "$matchedRecords" ]]; then
                    echo -e "\e[31m---No Matched Records Founded---\e[0m"
                else
                    echo -e "\e[33m--------------Matched Recored--------------\e[0m"
                    awk -F':' '{printf "%s | ", $1}' ".$tableName-metadata"
                    echo -e "\n\e[33m----------------------values-----------------\e[0m"
                    echo "$matchedRecords"
                fi

            fi
        else
            echo -e "\e[31m---Invalid Input---\e[0m"
        fi  
    else
        echo -e "\e[31m---Table is empty---\e[0m"
    fi
}




#------------------------------------ select Menu --------------------
function select_table_menu() {
    ./../../scripts/table-scripts/table-list.sh
    if [[ ! -z "$tableList" ]]; then
        read -p "Please Enter Table Name You want to select from : " tableName
        if validate_name "$tableName" ; then

            if [[ -f "$tableName" && -f ".$tableName-metadata" ]]; then
                #-------------Select Menu----------------
                choices=("Select All Records" "Select By Column" "Select By Record Value" "Exit")
                while [ true ];
                do  
                    
                    echo -e "\e[33m************************************Select Menu************************************\e[0m"
                    for ((i=0; i<${#choices[@]}; i++)); do
                        echo -e "\e[33m$((i+1)). ${choices[i]}\e[0m"
                    done
                    read -p "Enter Select Operation Number: " choice
                    case $choice in
                        1)  clear
                            selectAll 
                        ;;
                        2)   clear    
                            selectByColumn
                        ;;
                        3)  clear
                            selectByRecord
                        ;;
                        4)  clear
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
            echo -e "\e[31m---Invalid table name---\e[0m"
        fi
    fi    
    
}

select_table_menu