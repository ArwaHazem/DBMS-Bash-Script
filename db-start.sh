#!/bin/bash

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
#-----------------------------------------------------

echo $PWD
if [[ -d "./DB" ]]; then
    cd DB
else
   mkdir DB
   cd DB
fi

./../db-menu.sh