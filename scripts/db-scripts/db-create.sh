#! /usr/bin/bash
export LC_COLLATE=C
shopt -s extglob
source ./../scripts/utilities.sh

function creat_database(){
    if [[ "$(basename "$PWD")" == "DB" ]]; then
        read -p "Please Enter DataBase Name: " dbname
        # Check if dbname matches the regex pattern
        if validate_name "$dbname" ; then
            if [ -d "$dbname" ]; then
                echo "  Database already exist!!"
            else
                mkdir $dbname
                echo "  Database created successfully!"

            fi

        else
            echo "  Invalid database name (database name -contain only character,numbers, _ 
                                       - start with character or _ only  )"
        fi
else 
    echo "Invalid Path"    
fi
    
}

creat_database

