#!/bin/bash
cd "$(dirname "$0")"

source .build-ver
OLD_URL=$BUILD_URL
echo OLD_URL $OLD_URL 
git fetch

if [ $(git rev-parse HEAD) != $(git rev-parse @{u}) ]; then
    git reset --hard @{u}
    source .build-ver
    NEW_URL=$BUILD_URL
    echo NEW_URL $NEW_URL

    if [ "${OLD_URL}" != "${NEW_URL}" ]; then

        HTTP_STATUS=$(curl -o /dev/null -s -w "%{http_code}" -I -L \
            -H "User-Agent: MinecraftUpdater/1.0" \
            "${BUILD_URL}")

        if [ "$HTTP_STATUS" -eq 200 ]; then
            bash make_backup.sh
            export BUILD_URL
            docker compose up -d
            
            echo "Update to ${BUILD_URL} complete at $(date)"
        else
            echo "URL ${BUILD_URL} returned HTTP ${HTTP_STATUS}. are u sure its legit"
            exit 1
        fi
    fi
fi