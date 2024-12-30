#!/bin/sh
set -e

qbt_username="${QBT_USERNAME:-admin}"
qbt_password="${QBT_PASSWORD:-adminadmin}"
qbt_addr="${QBT_ADDR:-http://localhost:8080}" # ex. http://10.0.1.48:8080
glue_addr="${GLUE_ADDR:-http://localhost:8000}" # ex. http://10.0.1.48:8000
glue_username="${GLUE_USERNAME:-admin}"
glue_password="${GLUE_PASSWORD:-password}"

port_number=$(curl --fail --silent --show-error -u $glue_username:$glue_password $glue_addr/v1/openvpn/portforwarded | jq '.port')

curl --fail --silent --show-error --cookie-jar /tmp/cookies.txt --cookie /tmp/cookies.txt --header "Referer: $qbt_addr" --data "username=$qbt_username" --data "password=$qbt_password" $qbt_addr/api/v2/auth/login 1> /dev/null

listen_port=$(curl --fail --silent --show-error --cookie-jar /tmp/cookies.txt --cookie /tmp/cookies.txt $qbt_addr/api/v2/app/preferences | jq '.listen_port')

echo "Updating port from $listen_port to $port_number"

if [ ! "$listen_port" ]; then
    echo "Could not get current listen port, exiting..."
    exit 1
fi

if [ "$port_number" = "$listen_port" ]; then
    echo "Port already set, exiting..."
    exit 0
fi

echo "Updating port to $port_number"

curl --fail --silent --show-error --cookie-jar /tmp/cookies.txt --cookie /tmp/cookies.txt --data-urlencode "json={\"listen_port\": $port_number}"  $qbt_addr/api/v2/app/setPreferences

echo "Successfully updated port"
