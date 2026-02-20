#!/bin/bash
cd "$(dirname "$0")"

source .build-ver
OLD_URL=$CUSTOM_SERVER
echo OLD_URL $OLD_URL 
git fetch

if [ $(git rev-parse HEAD) != $(git rev-parse @{u}) ]; then
    git reset --hard @{u}
    source .build-ver
    NEW_URL=$CUSTOM_SERVER
    echo NEW_URL $NEW_URL

    if [ "${OLD_URL}" != "${NEW_URL}" ]; then

        HTTP_STATUS=$(curl -o /dev/null -s -w "%{http_code}" -I -L \
            -H "User-Agent: MinecraftUpdater/1.0" \
            "${CUSTOM_SERVER}")

        if [ "$HTTP_STATUS" -eq 200 ]; then
            bash make_backup.sh
            export CUSTOM_SERVER
            docker compose up -d
            
            echo "Update to ${CUSTOM_SERVER} complete at $(date)"
        else
            echo "URL ${CUSTOM_SERVER} returned HTTP ${HTTP_STATUS}. are u sure its legit"
            exit 1
        fi
    fi
fi