#!/bin/bash

export LC_COLLATE=C
shopt -s extglob
source ./../../scripts/utilities.sh

tableList=$(list_valid_tables "$PWD")

./../../scripts/table-scripts/table-list.sh
function insert_into_table {
    if [[ ! -z "$tableList" ]]; then
        read -p "please enter table name: " tablename
        if [[ -f $tablename && -f ".${tablename}-metadata" ]]; then
            #code logic
            field_count=0
            newrecord=""
            declare -i pk_index
            colnames=($(cut -f1 -d: ".${tablename}-metadata"))
            coltypes=($(cut -f2 -d: ".${tablename}-metadata"))
            pk_index=$(awk -F: '$3 == "PK" {print NR; exit}' ".${tablename}-metadata")
            ((pk_index--))

            for ((i=0; i<${#colnames[@]}; i++)); do
                colname="${colnames[i]}"
                coltype="${coltypes[i]}"

                while true; do
                    read -p "Enter value for column '$colname': " colvalue
                    
                    # Validating input against column type
                    if [[ "$coltype" == "int" && ! "$colvalue" =~ ^-?[0-9]+$ ]]; then
                        echo -e "\e[31mInvalid input. Column type is 'int', please enter a valid integer value.\e[0m"
                    elif [[ "$coltype" == "string" && ! "$colvalue" =~ ^[^:]+$ ]]; then
                        echo -e "\e[31mInvalid input. Column type is 'int', please enter a valid integer value.\e[0m"
                    else
                        # Datatype is valid
                        if [[ "$i" -eq "$pk_index" ]]; then
                            primary_key_values=($(cut -f"$((i+1))" -d: "$tablename"))
                            if [[ " ${primary_key_values[*]} " =~ " $colvalue " ]]; then
                                echo -e "\e[31mValue already exists. Please enter a unique value for the primary key.\e[0m"
                            else
                                newrecord+="$colvalue:"
                                break # PK is unique theb input is valid
                            fi
                        else
                            newrecord+="$colvalue:"
                            break # Not a PK and input is valid
                        fi
                    fi
                done
            done

            if [[ -n "$newrecord" ]]; then
                echo "${newrecord::-1}" >> "$tablename"
                clear
                echo -e "\e[31mNew record added to $tablename successfully\e[0m"
            else
                echo -e "\e[31m---No valid record to add----\e[0m"
            fi
        else
            clear
            echo -e "\e[31m---table $tablename does not exist---\e[0m"
        fi
    fi    
}

insert_into_table