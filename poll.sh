#!/bin/bash
git fetch

if [ $(git rev-parse HEAD) != $(git rev-parse @{u}) ]; then
    bash make_backup
    git pull
    docker compose up -d
    echo "Minecraft updated to latest Paper build at $(date)"
fi