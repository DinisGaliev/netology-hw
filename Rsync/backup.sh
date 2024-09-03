#!/bin/bash

SOURCE_DIR="/home/digaliev"
TARGET_DIR="/tmp/backup"

rsync -a --checksum "$SOURCE_DIR" "$TARGET_DIR" > /dev/null 2>> /var/log/backup.log
if [ $? -eq 0 ]; then
 echo "[$(date)] Резервное копирование выполнено" >> /var/log/backup.log
else
 echo "[$(date)] Ошибка выполнения резервного копирования" >> /var/log/backup.log
fi
