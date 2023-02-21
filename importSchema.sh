#!/bin/bash

if [[ $# -eq 0 ]] ; then
    echo 'Please provide a valid json file as argument.'
    exit 0
fi

. env.config

file=$1

authJSON='{"grant_type":"password", "username":"'${username}'", "password":"'${password}'"}'

token=$(curl -k -H "Content-Type: application/json" \
-X POST -d "$authJSON" \
"${domain}"/auth/token | \
jq -r '.access_token')

echo Importing $file
schema=$(jq -c '.' $file)
type="$(basename "$file" .json)"
curl -k -H "Content-Type: application/json" \
-X PUT -d "$schema" --location-trusted\
-L "${domain}"/schemas/"$type" -H\
"Authorization: Bearer $token"
