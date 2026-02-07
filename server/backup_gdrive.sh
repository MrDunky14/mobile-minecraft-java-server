#!/bin/bash
BACKUP_NAME="backup-$(date +%Y-%m-%d-%H%M).tar.gz"
REMOTE="gdrive:Minecraft_Backups"
echo ">>> [Backup] Zipping world..."
tar -czf $BACKUP_NAME world world_nether world_the_end config server.properties
echo ">>> [Backup] Uploading to Google Drive..."
if rclone listremotes | grep -q "gdrive:"; then
    rclone copy $BACKUP_NAME $REMOTE --progress
    rclone delete --min-age 7d $REMOTE
    rm $BACKUP_NAME
    echo ">>> [Backup] Complete!"
else
    echo ">>> [Error] Rclone not configured! Run 'rclone config' first."
fi
