#!/bin/bash

export LC_COLLATE=C
shopt -s extglob

source ./../../scripts/utilities.sh

dbname=$(basename "$PWD")
tablesList=$(find . -maxdepth 1 -type f -not -name ".*" | cut -f2 -d'/')


function selectAll() {
    if [ -s "$tableName" ]; then
        echo "---------------------------\"$tableName table\" records-------------------------"
        awk -F':' '{printf "%s | ", $1}' ".$tableName-metadata"
        echo -e "\n----------------------values-----------------"
        sed 's/:/ | /g' "$tableName"
    else
        echo "---Table is empty----"
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
                echo "---Invalid Column Number---"
            else
                echo "-----------------Column \"$columnName\" data-------------"
                awk -F : -v colNum="$columnNumber" '{print $colNum;}' "$tableName"
            fi
        else
            echo "---Invalid Input---"
        fi  
    else
        echo "---Table is empty---"
    fi
}


function selectByRecord() {
    if [ -s "$tableName" ]; then
        awk -F ":" '{print NR"-" $1 }' ".$tableName-metadata"
        columnsNum=$(wc -l < ".$tableName-metadata")

        read -p "Enter Column Number: " columnNumber
        if [[ $columnNumber =~ ^[1-9][0-9]*$ ]]
        then
            columnName=$(awk -F ':' -v columnNum="$columnNumber" 'NR == columnNum {print $1}' ".$tableName-metadata")
            if ((columnNumber < 1 || columnNumber > columnsNum))
            then
                echo "---Invalid Column Number---"
            else
                #Logic is here 
                read -p "Enter Value: " recordValue 
    
                matchedRecords=$(awk -F : -v colNum="$columnNumber" -v value="$recordValue" '$colNum == value {print $0}' "$tableName")

                if [[ -z "$matchedRecords" ]]; then
                    echo "---No Matched Records Founded---"
                else
                    echo "--------------Matched Recored--------------"
                    echo "$matchedRecords"
                fi

            fi
        else
            echo "---Invalid Input---"
        fi  
    else
        echo "---Table is empty---"
    fi
}




#------------------------------------ select Menu --------------------
function select_table_menu() {
    #List existed tables 
    if [[ -z "$tablesList" ]]; then
        echo "------No Tables exist in $dbname DataBase ------" 
    else
        echo  "***********Availabe Tables*************"
        typeset -i tableNumber=1
        for table in $tablesList; do
            echo "$tableNumber- $table"
            ((tableNumber++))
        done
        echo "*****************************************"

        read -p "Please Enter Table Name You want to select from : " tableName
        if validate_name "$tableName" ; then

            if [[ -f "$tableName" && -f ".$tableName-metadata" ]]; then
                #-------------Select Menu----------------
                choices=("Select All Records" "Select By Column" "Select By Record Value" "Exit")
                while [ true ];
                do
                    echo "************************************Select Menu************************************"
                    for ((i=0; i<${#choices[@]}; i++)); do
                        echo "$((i+1)). ${choices[i]}"
                    done
                    read -p "Enter Select Operation Number: " choice
                    case $choice in
                        1)  
                            selectAll
                            
                        ;;
                        2) 
                            
                            selectByColumn
                        ;;
                        3)  
                            selectByRecord
                        ;;
                        4)
                            break
                        ;;
                        *) 
                        echo "---Invalid Input---"
                    esac
                done

            else
                echo "$tableName table does not exist"
            fi
        else
            echo "---Invalid table name---"
        fi
    fi
}

select_table_menu

