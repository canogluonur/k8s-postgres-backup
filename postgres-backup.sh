#!/bin/bash

cd /home/root
date1=$(date +%Y%m%d-%H%M)
mkdir -p pg-backup
PGPASSWORD="$PG_PASS" pg_dumpall -h postgresql-postgresql.devtroncd -p 5432 -U postgres > pg-backup/postgres-db.sql
file_name="pg-backup-$date1.tar.gz"

# Compressing backup file for upload
tar -zcvf "$file_name" pg-backup

notification_msg="Postgres-Backup-failed"
filesize=$(stat -c %s "$file_name")
mfs=10
if [[ "$filesize" -gt "$mfs" ]]; then
  # Uploading to S3
  aws s3 cp "$file_name" "$S3_BUCKET"
  notification_msg="Postgres-Backup-was-successful"
fi

# Print the result to the console
echo "$(date +%Y-%m-%d\ %H:%M:%S) - $notification_msg"
