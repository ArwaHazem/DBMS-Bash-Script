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
                echo "Update rows with a condition on column is in progress"
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