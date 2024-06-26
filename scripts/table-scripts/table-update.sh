#!/bin/bash

export LC_COLLATE=C
shopt -s extglob


source ./../../scripts/utilities.sh
tableList=$(list_valid_tables "$PWD")

list_all_columns() {
    echo -e "\e[33mList of all columns:\e[0m"
    awk -F ':' '{print $1}' ".$1-metadata"
}

update_all_rows() {
    coltype=""
    column_name=""
    declare -i line_number
    table_name="$1"
    list_all_columns "$table_name"
        read -p "Enter the column name you want to update: " column_name
        
        # Check if the column exists in metadata
        if grep -q "^$column_name:" ".$table_name-metadata"; then
            if grep -q "^$column_name:[^:]*:PK$" ".$table_name-metadata"; then
                echo -e "\e[31mCannot update primary key column $column_name with same value for all records\e[0m"
            else
                line_number=$(grep -n "^$column_name:" ".$table_name-metadata" | cut -d ':' -f1)
                coltype=$(grep "^$column_name:" ".$table_name-metadata" | cut -d ':' -f2)
                
                read -p "Enter value for column '$column_name': " colvalue
        
                # Validating input against column type
                if [[ "$coltype" == "int" && ! "$colvalue" =~ ^-?[0-9]+$ ]]; then
                    echo -e "\e[31mInvalid input. Column type is 'int', please enter a valid integer value.\e[0m"
                elif [[ "$coltype" == "string" && ! "$colvalue" =~ ^[^:]+$ ]]; then
                    echo -e "\e[31mInvalid input. Column type is 'string', please enter a valid string value.\e[0m"
                else
                    #valid input to replace with
                    awk -v field="$line_number" -v new="$colvalue" 'BEGIN{FS=OFS=":"}{$field=new; print $0}' "$table_name" > temp_file
                    cat temp_file > "$table_name"
                    rm -f temp_file
                    clear
                    echo -e "\e[32mcolumn $column_name updated successfully for all records\e[0m"


                fi
            fi
        else
            echo -e "\e[91mColumn $column_name does not exist\e[0m"
        fi
}

update_with_condition() {
    table_name="$1"
    declare -i num_of_updates_occured=0

    list_all_columns "$table_name"


        read -r -p "Enter valid column name for the condition: " condition_column_name

        # Check if the column exists in metadata
        if grep -q "^$condition_column_name:" ".$table_name-metadata"; then
            condition_column_num=$(grep -n "^$condition_column_name:" ".$table_name-metadata" | cut -d ':' -f1)
            read -r -p "Enter the value for the condition: " condition_value
            ###
            valid_input=false
                read -r -p "Enter the column name you want to update: " column_to_update
                if grep -q "^$column_to_update:" ".$table_name-metadata"; then
                    column_to_update_num=$(grep -n "^$column_to_update:" ".$table_name-metadata" | cut -d ':' -f1)
                    coltype=$(grep "^$column_to_update:" ".$table_name-metadata" | cut -d ':' -f2)


                    read -r -p "Enter the new value for the column $column_to_update: " new_value
                    # Validating input against column type
                    if [[ "$coltype" == "int" && ! "$new_value" =~ ^-?[0-9]+$ ]]; then
                        echo -e "\e[91mInvalid input. Column type is 'int', please enter a valid integer value.\e[0m"
                    elif [[ "$coltype" == "string" && ! "$new_value" =~ ^[^:]+$ ]]; then
                        echo -e "\e[91mInvalid input. Column type is 'string', please enter a valid string value.\e[0m"
                    else
                        #valid datatype but check if it is primary key
                        num_of_updates_occured=$(awk -v search_col="$condition_column_num" -v search_value="$condition_value" 'BEGIN{FS=OFS=":"} {if ($search_col==search_value) print $0}' "$table_name" | wc -l )
                        if grep -q "^$column_to_update:[^:]*:PK$" ".$table_name-metadata"; then
                            if [[ $num_of_updates_occured -le 1 ]]; then
                                primary_key_values=($(cut -f"$((column_to_update_num))" -d: "$tablename"))
                                if [[ " ${primary_key_values[*]} " =~ " $new_value " ]]; then
                                    echo -e "\e[91mValue already exists. Please enter a unique value for the primary key.\e[0m"
                                else
                                    #valid data to replace
                                    # PK is unique then input is valid
                                    valid_input=true
                                fi
                            else 
                                echo -e "\e[91mCan't update more than one record by same PK value.\e[0m"
                            fi    

                        else
                            # Not a PK and input is valid
                            valid_input=true
                        fi

                    fi

                    if $valid_input; then
                        num_of_updates_occured=$(awk -v search_col="$condition_column_num" -v search_value="$condition_value" 'BEGIN{FS=OFS=":"} {if ($search_col==search_value) print $0}' "$table_name" | wc -l )
                        if [[ $num_of_updates_occured -gt 0 ]]; then
                            awk -v update_col_num="$column_to_update_num" -v new_val="$new_value" -v search_col="$condition_column_num" -v search_value="$condition_value" 'BEGIN{FS=OFS=":"} {if ($search_col==search_value) {$update_col_num=new_val} print $0}' "$table_name"> temp_file
                            cat temp_file > "$table_name"
                            rm -f temp_file
                            echo -e "\e[32m($num_of_updates_occured) rows Updated Successfully\e[0m"
                        else
                            echo -e "\e[32m($num_of_updates_occured) rows matched\e[0m"

                        fi
                    fi

                else
                    echo -e "\e[91mColumn $column_to_update does not exist\e[0m"
                fi

        else
            echo -e "\e[91mColumn $condition_column_name does not exist\e[0m"
        fi

    ############### 
}

update_row_with_pk() {
    table_name="$1"
    list_all_columns "$table_name"
    is_success=false
    pkname=$(grep ':PK' ".$table_name-metadata" | cut -d':' -f1)
    pk_col_num=$(grep -n ':PK' ".$table_name-metadata" | cut -d':' -f1)
    pk_index=$((pk_col_num - 1))


    colnames=($(cut -f1 -d: ".$table_name-metadata"))
    coltypes=($(cut -f2 -d: ".$table_name-metadata"))
    newvalues=()

    read -r -p "Enter the value of the condition for your primary key $pkname : " condition_value
    primary_key_values=($(cut -f"$((pk_col_num))" -d: "$table_name"))

    if [[ " ${primary_key_values[*]} " =~ " $condition_value " ]]; then

        for ((i=0; i<${#colnames[@]}; i++)); do
            if [[ "$i" -eq "$pk_index" ]]; then
                newvalues+=("$condition_value")
                continue
            fi
            colname="${colnames[i]}"
            coltype="${coltypes[i]}"

            while true; do
                read -p "Enter value for column '$colname': " colvalue

                if [[ "$coltype" == "int" && ! "$colvalue" =~ ^-?[0-9]+$ ]]; then
                    echo -e "\e[91mInvalid input. Column type is 'int', please enter a valid integer value.\e[0m"
                elif [[ "$coltype" == "string" && ! "$colvalue" =~ ^[^:]+$ ]]; then
                    echo -e "\e[91mInvalid input. Column type is 'string', please enter a valid string value.\e[0m"
                else
                    newvalues+=("$colvalue")
                    break
                fi
            done
        done

        for ((i=0; i<${#newvalues[@]}; i++)); do
            if [[ "$i" -eq "$pk_index" ]]; then
                continue
            fi
            is_success=true
            awk -v i="$((i + 1))" -v newvalue="${newvalues[$i]}" -v search_col="$pk_col_num" -v search_value="$condition_value" 'BEGIN{FS=OFS=":"} { if ($search_col==search_value){$i=newvalue} print $0}' "$table_name"> temp_file
            cat temp_file >"$table_name"
            rm -f temp_file
        done
        if $is_success; then
            echo -e "\e[32mrow with $pkname = $condition_value  updated successfully\e[0m"
        else
            echo -e "\e[91mthis update cannot be applied\e[0m"
        fi
        

    else
        echo -e "\e[91mvalue $condition_value does not exist\e[0m"
    fi



  
}

./../../scripts/table-scripts/table-list.sh
if [[ ! -z "$tableList" ]]; then
    read -p "please enter table name: " tablename
    if [[ -f $tablename && -f ".${tablename}-metadata" ]]; then
        while true; do
            echo -e "\e[33m*******************************************\e[0m"
            echo -e "\e[33m1. Update all rows with a certain column value\e[0m"
            echo -e "\e[33m2. Update rows with a condition on column\e[0m"
            echo -e "\e[33m3. Update all row fields with pk\e[0m"
            echo -e "\e[33m4. Exit\e[0m"
            read -p "Enter your choice: " choice

            case $choice in
                1)
                    if [ -s "$tablename" ]; then
                        clear
                        update_all_rows "$tablename"
                    else
                        echo -e "\e[91m---Table is empty----\e[0m"
                    fi
                    
                    ;;
                2)
                    if [ -s "$tablename" ]; then
                        clear
                        update_with_condition "$tablename"
                    else
                        echo -e "\e[91m---Table is empty----\e[0m"
                    fi
                    
                    ;;
                3)
                    if [ -s "$tablename" ]; then
                        clear
                        update_row_with_pk "$tablename"
                    else
                        echo -e "\e[91m---Table is empty----\e[0m"
                    fi
                    ;;
                4)
                    echo -e "\e[91mExiting...\e[0m"
                    exit
                    ;;
                *)
                    echo -e "\e[91mInvalid choice. Please enter a valid option.\e[0m"
                    ;;
            esac
        done
    else
        clear
        echo -e "\e[91mtable $tablename does not exist\e[0m"
    fi
fi    
