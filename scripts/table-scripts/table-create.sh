#!/bin/bash

export LC_COLLATE=C
shopt -s extglob

source ./../../scripts/utilities.sh

function create_table {
    declare -a columns_names
    declare -a columns_types
    read -p "Enter Table Name: " tablename
    if validate_name "$tablename" ; then
            if [[ -f "$tablename" ]]; then
                clear
                echo "---Table "$tablename" already exists---"
            else
                read -p "please enter number of columns: " num_of_cols
                while [[ ! "$num_of_cols" =~ ^[1-9][0-9]*$ ]]; do
                    echo "Number of columns must be positive number"
                    read -p "please enter number of columns: " num_of_cols
                done
                declare -i i=1
                while [ $i -le $num_of_cols ]; do
                    while [ true ]; do
                        read -p "please enter name of column "$i": " column
                        if validate_name "$column" ; then
                            if [[ " ${columns_names[*]} " =~ " $column " ]]; then
                                echo "---Duplicate Column Name---"
                            else
                                columns_names+=("$column")
                                break
                            fi
                        else
                            echo "---Invalid Column Name---"
                        fi
                    done
                    while [ true ]; do
                        read -p "please enter datatype of column: $column, 1 for int 2 for string: " option
                        case $option in
                        1)
                            columns_types+=("int")
                            #push string to type array
                            break
                            ;;
                        2)
                            columns_types+=("string")
                            #push string to type array
                            break
                            ;;
                        *)
                            echo "---Invalid Datatype---"
                            ;;
                        esac
                    done
                    i=$((i+1))

                done
                #another loop for primary key selection
                for ((idx=0; idx<${#columns_names[@]}; idx++)); do
                    echo "$((idx+1)): ${columns_names[idx]}"
                done
                while true; do
                    read -p "please enter number of your primary key (mandatory): " pkindex
                    if [[ ! "$pkindex" =~ ^[1-9][0-9]*$ ]]; then
                        echo "Error: Please enter a valid positive integer"
                        continue
                    fi

                    pkindex=$((pkindex-1))
                    # Check if the pkindex is within the range of the array
                    if (( pkindex >= ${#columns_names[@]} || pkindex < 0 )); then
                        echo "Error: index out of range."
                        continue
                    fi

                    # Display the value at the specified pkindex
                    echo "${columns_names[pkindex]} is selected as primary key"
                    break
                done
                touch "$tablename"
                
                # Create the metadata file
                touch ".${tablename}-metadata"
                
                # Write metadata to the metadata file
                for ((i=0; i<${#columns_names[@]}; i++)); do
                    if (( i == pkindex )); then
                        echo "${columns_names[i]}:${columns_types[i]}:PK" >> ".${tablename}-metadata"
                    else
                        echo "${columns_names[i]}:${columns_types[i]}" >> ".${tablename}-metadata"
                    fi
                done
                clear
                echo "---Table created successfully---"

            fi
    else
        clear
        echo "---Invalid table name---"

    fi
}
create_table
