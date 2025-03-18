#!/bin/bash

# get curent script path
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
RANDSLEEP=$(awk 'BEGIN{srand(); print int(rand()*(3600+1))}')

# check if the router cron file exists
if [ ! -f /etc/cron.d/router ]; then
    echo "[#] Creating cron file for router"
    echo "5 12 */2 * * root sleep ${RANDSLEEP} && docker exec router " > /etc/cron.d/router
else
    echo "[#] Cron file for router already exists"
fi
# check if the cron certbot file exists
if [ ! -f /etc/cron.d/certbot ]; then
    echo "[#] Creating cron file for certbot"
    echo "0 12 */2 * * root sleep ${RANDSLEEP} && docker exec certbot /opt/certbot/renew.sh" > /etc/cron.d/certbot
else
    echo "[#] Cron file for certbot already exists"
fi

# if the cron file exists, check if the cron job is running
if [ -z "$(ps -ef | grep cron | grep -v grep | grep router)" ]; then
    echo "[#] Starting cron for router"
    crontab &
fi

# checks if the router container and certbot container are both running
if [ -z "$(docker ps -q -f name=router)" ] || [ -z "$(docker ps -q -f name=certbot)" ]; then
    echo "[#] Router or Certbot container is not running, starting them"
    docker compose -f $DIR/docker-compose.yml up -d
else
    echo "[#] Router and Certbot containers are running"
fi