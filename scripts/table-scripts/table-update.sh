export LC_COLLATE=C
shopt -s extglob

list_all_columns() {
    echo "List of all columns:"
    awk -F ':' '{print $1}' ".$1-metadata"
}

update_all_rows() {
    coltype=""
    column_name=""
    declare -i line_number
    table_name="$1"
    list_all_columns "$table_name"
    while true; do
        read -p "Enter the column name you want to update: " column_name
        
        # Check if the column exists in metadata
        if grep -q "^$column_name:" ".$table_name-metadata"; then
            if grep -q "^$column_name:[^:]*:PK$" ".$table_name-metadata"; then
                echo "Cannot update primary key column $column_name with same value for all records"
            else
                line_number=$(grep -n "^$column_name:" ".$table_name-metadata" | cut -d ':' -f1)
                coltype=$(grep "^$column_name:" ".$table_name-metadata" | cut -d ':' -f2)
                break
            fi
        else
            echo "Column $column_name not found."
        fi
    done
    ######enter new value for this col
    while true; do
        read -p "Enter value for column '$column_name': " colvalue
        
        # Validating input against column type
        if [[ "$coltype" == "int" && ! "$colvalue" =~ ^-?[0-9]+$ ]]; then
            echo "Invalid input. Column type is 'int', please enter a valid integer value."
        elif [[ "$coltype" == "string" && ! "$colvalue" =~ ^[^:]+$ ]]; then
            echo "Invalid input. Column type is 'string', please enter a valid string value."
        else
            #valid input to replace with
            awk -v field="$line_number" -v new="$colvalue" 'BEGIN{FS=OFS=":"}{$field=new}1' "$table_name" > temp_file
            cat temp_file > "$table_name"
            # remove temp file after
            #rm -f temp_file
            clear
            echo "column $column_name updated successfully for all records"
            break

        fi
    done
}

update_with_condition() {
    table_name="$1"
    declare -i num_of_updates_occured=0

    list_all_columns "$table_name"

    while true;do
        read -r -p "Enter valid column name for the condition: " condition_column_name

        # Check if the column exists in metadata
        if grep -q "^$condition_column_name:" ".$table_name-metadata"; then
            condition_column_num=$(grep -n "^$condition_column_name:" ".$table_name-metadata" | cut -d ':' -f1)
            read -r -p "Enter the value for the condition: " condition_value
            break
        else
            echo "Column $ondition_column_name does not exist"
        fi
    done
    ############### 
    valid_input=false
    while [ "$valid_input" = false ]; do
        read -r -p "Enter the column name you want to update: " column_to_update
        if grep -q "^$column_to_update:" ".$table_name-metadata"; then
            column_to_update_num=$(grep -n "^$column_to_update:" ".$table_name-metadata" | cut -d ':' -f1)
            coltype=$(grep "^$column_to_update:" ".$table_name-metadata" | cut -d ':' -f2)


            while true;do
                read -r -p "Enter the new value for the column $column_to_update: " new_value
                # Validating input against column type
                if [[ "$coltype" == "int" && ! "$new_value" =~ ^-?[0-9]+$ ]]; then
                    echo "Invalid input. Column type is 'int', please enter a valid integer value."
                elif [[ "$coltype" == "string" && ! "$new_value" =~ ^[^:]+$ ]]; then
                    echo "Invalid input. Column type is 'string', please enter a valid string value."
                else
                    #valid datatype check if primary key
                    if grep -q "^$column_to_update:[^:]*:PK$" ".$table_name-metadata"; then
                        primary_key_values=($(cut -f"$((column_to_update_num))" -d: "$tablename"))
                        if [[ " ${primary_key_values[*]} " =~ " $new_value " ]]; then
                            echo "Value already exists. Please enter a unique value for the primary key."
                        else
                            #valid data to replace
                            # PK is unique then input is valid
                            valid_input=true
                            break 
                        fi
                    else
                        # Not a PK and input is valid
                        valid_input=true
                        break 
                    fi

                fi
            done
            if $valid_input; then
                num_of_updates_occured=$(awk -F: -v update_col_num=$column_to_update_num -v new_val=$new_value -v search_col=$condition_column_num -v search_value=$condition_value 'BEGIN{OFS=":";} {if ($search_col==search_value) print $0}' "$table_name"| wc -l )
                awk -F: -v update_col_num=$column_to_update_num -v new_val=$new_value -v search_col=$condition_column_num -v search_value=$condition_value 'BEGIN{OFS=":";} {if ($search_col==search_value) {$update_col_num=new_val} print $0}' "$table_name"> temp_file
                cat temp_file > "$table_name"
                rm temp_file
            fi

        else
            echo "Column $column_to_update does not exist"
        fi
    done
    ######succesful process
    if [[ $num_of_updates_occured -gt 0 ]]; then
        echo "($num_of_updates_occured) rows Updated Successfully"
    else
        echo "($num_of_updates_occured) rows matched"

    fi
}


./../../scripts/table-scripts/table-list.sh
read -p "please enter table name: " tablename
if [[ -f $tablename && -f ".${tablename}-metadata" ]]; then
    while true; do
        echo "*******************************************"
        echo "1. Update all rows with a certain column value"
        echo "2. Update rows with a condition on column"
        echo "3. Exit"
        read -p "Enter your choice: " choice

        case $choice in
            1)
                update_all_rows "$tablename"
                ;;
            2)
                update_with_condition "$tablename"
                ;;
            3)
                echo "Exiting..."
                exit
                ;;
            *)
                echo "Invalid choice. Please enter a valid option."
                ;;
        esac
    done
else
    clear
    echo "table $tablename does not exist"
fi