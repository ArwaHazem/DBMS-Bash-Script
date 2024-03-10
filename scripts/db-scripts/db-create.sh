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
                echo -e "\e[31m---Database already exist!---\e[0m"
            else
                mkdir $dbname
                echo -e "\e[32m---Database created successfully---\e[0m"

            fi

        else
            echo -e "\e[31mInvalid database name [database name: -contain only character,numbers, _ 
                                      - start with letter or _ only]\e[0m"

        fi
else 
    echo -e "\e[31m---Invalid Path---\e[0m"   
fi
    
}

creat_database

