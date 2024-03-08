#!/bin/bash

export LC_COLLATE=C
shopt -s extglob

source ./../../scripts/utilities.sh

dbname=$(basename "$PWD")
tablesList=$(find . -maxdepth 1 -type f -not -name ".*" | cut -f2 -d'/')


function deleteAll(){
    if [ -s "$tableName" ]; then
        echo -n > "$tableName"
        if [ ! -s "$tableName" ]; then
            echo "\"$tableName\" table deleted successfully"
        else
            echo "Error in delete \"$tableName\""
        fi    
    else
        echo "---Table is empty---"
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
                echo "---Invalid Column Number---"

            else 
                #logic is here
                read -p "Enter Value: " fieldValue 
    
                matchedRecords=$(awk -F : -v colNum="$columnNumber" -v value="$fieldValue" '$colNum == value {print $0}' "$tableName")

                if [[ -z "$matchedRecords" ]]; then
                    echo "---No Matched Records Founded To Delete---"
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
                        echo "$deletedRecords record(s) deleted successfully"
             

                        else 
                            echo "---Error in deleting---"


                    fi
                fi

            fi    

        else 
            echo "---Invalid Input---"
        fi
 
    else
        echo "---Table is empty---"
    fi   

}



function delete_table_menu(){
  
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
                choices=("Delete All Records" "Delete Record By value" "Exist")
                while true ; do
                    echo "--------------Delete Menu---------------"
                    for ((i=0; i<${#choices[@]}; i++)); do
                        echo "$((i+1)). ${choices[i]}"
                    done

                    read -p "Enter Delete Operation Number: " choice
                    case $choice in 
                        1) 
                           deleteAll
                        ;;
                        2) 
                            deleteByRecord
                        ;;
                        3)
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
            echo "---Invalid Table Name---"
        fi        
    fi

}
delete_table_menu