#!/bin/bash

readarray -t db_params < <(python3 $HOME/boris_bb/params/readParams.py $1)

export dbuser=$(echo $db_params | jq -r '.["user"]')
export dbversion=$(echo $db_params | jq -r '.["version"]')
export dbport=$(echo $db_params | jq -r '.["port"]')
export dbtablespace=$(echo $db_params | jq -r '.["tablespace"]')
export productname=$(echo $db_params | jq -r '.["productname"]')

export CON=" -d ${dbname} -p ${dbport} -U ${dbuser}"
