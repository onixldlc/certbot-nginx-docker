#!/bin/bash

# get curent script path
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# check if the router cron file exists if it does remove it
if [ -f /etc/cron.d/router ]; then
    echo "[#] Removing router cron file for router"
    rm /etc/cron.d/router
else
    echo "[#] Cron router file for router does not exist"
fi
# check if the cron certbot file exists if it does remove it
if [ -f /etc/cron.d/certbot ]; then
    echo "[#] Removing cron file for certbot"
    rm /etc/cron.d/certbot
else
    echo "[#] Cron file for certbot does not exist"
fi

# checks if the router container and certbot container are both running, if it does stop them
if [ -n "$(docker ps -q -f name=router)" ] || [ -n "$(docker ps -q -f name=certbot)" ]; then
    echo "[#] Router or Certbot container is running, stopping them"
    docker compose -f $DIR/docker-compose.yml down
else
    echo "[#] Router and Certbot containers are not running"
fi