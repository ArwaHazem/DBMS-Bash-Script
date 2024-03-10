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
                echo -e "\e[31m---Table \"$tablename\" already exists---\e[0m"
            else
                read -p "please enter number of columns: " num_of_cols
                while [[ ! "$num_of_cols" =~ ^[1-9][0-9]{0,3}$ ]]; do
                    echo -e "\e[31mNumber of columns must be positive number\e[0m"
                    read -p "please enter number of columns: " num_of_cols
                done
                declare -i i=1
                while [ $i -le $num_of_cols ]; do
                    while [ true ]; do
                        read -p "please enter name of column \"$i\": " column
                        if validate_name "$column" ; then
                            if [[ " ${columns_names[*]} " =~ " $column " ]]; then
                                echo -e "\e[31m---Duplicate Column Name---\e[0m"
                            else
                                columns_names+=("$column")
                                break
                            fi
                        else
                            echo -e "\e[31m---Invalid Column Name---\e[0m"
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
                            echo -e "\e[31m---Invalid Datatype---\e[0m"
                            ;;
                        esac
                    done
                    i=$((i+1))

                done
                #another loop for primary key selection
                echo -e "\e[33m***********Column List************\e[0m"
                for ((idx=0; idx<${#columns_names[@]}; idx++)); do
                    echo -e "\e[33m$((idx+1)): ${columns_names[idx]}\e[0m"
                done
                while true; do
                    read -p "please enter number of your primary key (mandatory): " pkindex
                    if [[ ! "$pkindex" =~ ^[1-9][0-9]*$ ]]; then
                        echo -e "\e[31mError: Please enter a valid positive integer\e[0m"
                        continue
                    fi

                    pkindex=$((pkindex-1))
                    # Check if the pkindex is within the range of the array
                    if (( pkindex >= ${#columns_names[@]} || pkindex < 0 )); then
                        echo -e "\e[31mError: index out of range.\e[0m"
                        continue
                    fi

                    # Display the value at the specified pkindex
                    echo -e "\e[32m${columns_names[pkindex]} is selected as primary key\e[0m"
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
                echo -e "\e[32m---Table created successfully---\e[0m"

            fi
    else
        clear
        echo -e "\e[31m---Invalid table name---\e[0m"
    fi
}
create_table
