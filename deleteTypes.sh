#!/bin/bash

. env.config

authJSON='{"grant_type":"password", "username":"'${username}'", "password":"'${password}'"}'

token=$(curl -k -H "Content-Type: application/json" \
-X POST -d "$authJSON" \
-L "${domain}"/auth/token | \
jq -r '.access_token')

echo $token

data=$(curl -k -H "Content-Type: application/json" \
-L "${domain}"/objects/?query=*%3A* |
jq -r '.results')

# Get the total number of items
total_items=$(echo "$data" | jq '. | length')

# Initialize a counter
counter=0

echo "$data" | jq -c '.[]' | while read -r item; do
    id=$(echo $item | jq -r '.id')
    type=$(echo $item | jq -r '.type')

    ((counter++))

    echo -ne "Processing item $counter of $total_items\r"

    if [[ "$type" == "Schema" ]]; then
        echo "$id $type"
        continue
    fi

    skip_ids=(
    '21.T11967/1a7708f65582256a4538' 
    '21.T11967/72a3d8efd8e7fbfdfa80' 
    '21.T11967/f81e65ff241a6d89ea57' 
    '21.T11967/d57dcf10580df222531e'
    '21.T11967/36e20ebc3287e0918355'
    '21.T11967/9d2658ed774d7bae1545'
    '21.T11967/8d34858620756bf9c34b'
    '21.T11967/8f66009cdec984c901be'
    '21.T11967/0fa6f83e01640ec45c9e'
    '21.T11967/8a4276154f5957ca818b'
    '21.T11967/cd7fc0f4e30da1c3039b'
    '21.T11967/6aa00ecec6503b7dacec'
    )

    if [[ " ${skip_ids[@]} " =~ " ${id} " ]]; then
        echo "$id $type"
        continue
    fi

    curl -k -H "Content-Type: application/json" \
    -X DELETE -d "$authJSON" \
    -L "${domain}"/objects/$id \
    -H "Authorization: Bearer $token"

    # sleep 1
done

echo

echo "Processing complete. Processed $counter items."

exit 0