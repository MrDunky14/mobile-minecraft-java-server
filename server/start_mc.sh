#!/bin/bash
RAM="4096M"
while true; do
    echo ">>> 🟢 STARTING SERVER..."
    java -Xms1024M -Xmx$RAM -XX:+UseG1GC -jar fabric-server-launch.jar nogui
    echo ">>> 🔴 SERVER STOPPED. STARTING BACKUP..."
    ./backup_gdrive.sh
    echo ">>> 🔄 RESTARTING IN 5 SECONDS..."
    sleep 5
done
