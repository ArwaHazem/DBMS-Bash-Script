#!/bin/bash
echo $PWD
if [[ -d "./DB" ]]; then
    cd DB
else
   mkdir DB
   cd DB
fi

./../db-menu.sh