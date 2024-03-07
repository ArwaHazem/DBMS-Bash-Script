#! /usr/bin/bash
export LC_COLLATE=C
shopt -s extglob


function list_tables() {
    tablesList=$(find . -maxdepth 1 -type f -not -name ".*" | cut -f2 -d'/')
    

    if [[ -z "$tablesList" ]]; then
        echo "------No Tables exist in \"$(basename "$PWD")\" DataBase ------" 
    else
        typeset -i tableNumber=1
        echo  "***********Table List*************"
        for table in $tablesList; do
            echo "$tableNumber- $table"
            ((tableNumber++))
        done
        echo "***********************************"
    fi
}

list_tables
  
