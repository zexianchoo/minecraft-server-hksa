BACKUP_DIRNAME="mcbackup_$(date +%F).tar.gz"

echo "starting backup..."
echo

tar -cvpzf $BACKUP_DIRNAME minecraft-data

echo "Backup done! at $BACKUP_DIRNAME"
echo