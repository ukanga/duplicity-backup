#!/bin/bash
# vim: ai ts=4 sts=4 et sw=4 fileencoding=utf-8
# maintainer:ukanga
MYSQL_USER=
MYSQL_PASS=
MYSQL_DB=
MYSQL_BACKUP=
MYSQL_BACKUP_SOURCE=
MYSQL_BACKUP_TARGET=

ENCRYPT_KEY=

MONGO_DUMP=
MONGO_BACKUP_TARGET=
RESTORE_MONGO_BACKUP=
RESTORE_MYSQL_BACKUP=

if [ -r ~/.backup_config ]; then
    source ~/.backup_config
fi

mysql_backup()
{
    mysqldump -u $MYSQL_USER -p$MYSQL_PASS $MYSQL_DB > $MYSQL_BACKUP
}

cleanup_mysql()
{
    rm $MYSQL_BACKUP
}

mysql_duplicity_backup()
{
    duplicity --full-if-older-than 7D --encrypt-key $ENCRYPT_KEY $MYSQL_BACKUP_SOURCE $MYSQL_BACKUP_TARGET
}

restore_mysql()
{
    duplicity restore --hidden-encrypt-key $ENCRYPT_KEY $MYSQL_BACKUP_TARGET $RESTORE_MYSQL_BACKUP
}

mongo_backup()
{
    mongodump --out $MONGO_DUMP
}

cleanup_mongo()
{
    rm -rf $MONGO_DUMP
}

mongo_duplicity_backup()
{
    duplicity --full-if-older-than 7D --encrypt-key $ENCRYPT_KEY $MONGO_DUMP $MONGO_BACKUP_TARGET
}

restore_mongo()
{
    duplicity restore --hidden-encrypt-key $ENCRYPT_KEY $MONGO_BACKUP_TARGET $RESTORE_MONGO_BACKUP
}

if [ "$1" = "mysql" ]; then
    mysql_backup
    mysql_duplicity_backup
    cleanup_mysql
elif [ "$1" = "mongo" ]; then
    mongo_backup
    mongo_duplicity_backup
    cleanup_mongo
elif [[ "$1" = "restore" && "$2" = "mysql" ]]; then
    restore_mysql
elif [[ "$1" = "restore" && "$2" = "mongo" ]]; then
    restore_mongo
else
    echo "duplicity_backup - Encrypted incremental backup to local or remote storage, mongo n mysql"
fi
