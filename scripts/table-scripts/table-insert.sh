#!/bin/bash

export LC_COLLATE=C
shopt -s extglob

function insert_into_table {
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
                    echo "Invalid input. Column type is 'int', please enter a valid integer value."
                elif [[ "$coltype" == "string" && ! "$colvalue" =~ ^[^:]+$ ]]; then
                    echo "Invalid input. Column type is 'string', please enter a valid string value."
                else
                    # Datatype is valid
                    if [[ "$i" -eq "$pk_index" ]]; then
                        primary_key_values=($(cut -f"$((i+1))" -d: "$tablename"))
                        if [[ " ${primary_key_values[*]} " =~ " $colvalue " ]]; then
                            echo "Value already exists. Please enter a unique value for the primary key."
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
            echo "New record added to $tablename successfully"
        else
            echo "No valid record to add."
        fi
    else
        clear
        echo "table $tablename does not exist"
    fi
}

insert_into_table