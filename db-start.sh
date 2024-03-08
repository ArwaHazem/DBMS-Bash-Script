#!/bin/bash
source ./scripts/utilities.sh
#--------------- update scripts files premission -----------------------
chmod +x db-start.sh
chmod +x db-menu.sh
chmod +x table-menu.sh
chmod +x ./scripts/db-scripts/db-connect.sh
chmod +x ./scripts/db-scripts/db-create.sh
chmod +x ./scripts/db-scripts/db-drop.sh
chmod +x ./scripts/db-scripts/db-list.sh
chmod +x ./scripts/table-scripts/table-list.sh
chmod +x ./scripts/table-scripts/table-drop.sh
chmod +x ./scripts/table-scripts/table-select.sh
chmod +x ./scripts/table-scripts/table-update.sh
chmod +x ./scripts/table-scripts/table-create.sh
chmod +x ./scripts/table-scripts/table-insert.sh
chmod +x ./scripts/table-scripts/table-delete.sh
#-----------------------------------------------------------------------

clear
#echo $PWD
if [[ -d "./DB" ]]; then
    if check_permission "$USER" "$PWD/DB" "rwx" ; then
        cd DB
    else
        echo "permission denied: $USER user doesn't have permission!" 
    fi    
else
    if check_permission "$USER" "$PWD" "rwx" ; then
        mkdir DB
        cd DB
    else
        echo "permission denied: $USER user doesn't have permission!" 
    fi
fi


./../db-menu.sh

