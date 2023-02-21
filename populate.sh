#!/bin/bash

. env.config

authJSON='{"grant_type":"password", "username":"'${username}'", "password":"'${password}'"}'

token=$(curl -k -H "Content-Type: application/json" \
-X POST -d "$authJSON" \
-L "${domain}"/auth/token | \
jq -r '.access_token')

echo $token

for file in schemas/*; do
    echo Importing $file
    schema=$(jq -c '.' $file)
    type="$(basename "$file" .json)"
    curl -k -H "Content-Type: application/json" \
    -X PUT -d "$schema" --location-trusted \
    -L "${domain}"/schemas/"$type" -H\
    "Authorization: Bearer $token"
done

for file in instances/*; do
    echo Importing $file
    type="$(basename "$file" .json)"
    readarray -t instance < <(jq -c '.[]' $file)
    for item in "${instance[@]}"; do
        curl -k -H "Content-Type: application/json" \
        -X POST -d "$item" --location-trusted\
        -L "${domain}"/objects/?type="$type" -H \
        "Authorization: Bearer $token"
    done
done
