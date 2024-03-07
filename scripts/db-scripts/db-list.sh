#! /usr/bin/bash
export LC_COLLATE=C
shopt -s extglob

function list_databases() {
    if [[ "$(basename "$PWD")" == "DB" ]]; 
    then
        if [[ -z "$(ls -d */ 2> /dev/null | cut -f1 -d'/' )" ]]
            then
                echo -e "\nNo Database exist\n"
        else
            echo  "***********Database List*************"
            ls -d */ | cut -f1 -d'/'
            echo "***************************************"
        fi
    
else 
    echo "Invalid Path"    
fi

}
list_databases
  
