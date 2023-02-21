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
type="$(basename "$file" .json)"
readarray -t instance < <(jq -c '.[]' $file)
for item in "${instance[@]}"; do
    curl -k -H "Content-Type: application/json" \
    -X POST -d "$item" --location-trusted\
    -L "${domain}"/objects/?type="$type" -H \
    "Authorization: Bearer $token"
done
