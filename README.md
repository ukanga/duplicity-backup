Using duplicity - Encrypted incremental backup to local or remote storage.

### Install duplicity and Dependencies

Required: duplicity >=0.6.21

Ubuntu 12.04

    # su - -c "echo 'deb http://ppa.launchpad.net/duplicity-team/ppa/ubuntu precise main' | tee /etc/apt/sources.list.d/duplicity.list"
    # apt-key adv --keyserver hkp://keyserver.ubuntu.com:80  --recv AF953139C1DF9EF3476DE1D58F571BB27A86F4A2
    # apt-get update

Ubuntu

    # apt-get install duplicity

Arch linux

    # pacman -S duplicity

If you are going to use Amazon S3 storage install boto

    # apt-get install python-pip
    # pip install boto

You'll need the [couchdb-dump](https://www.npmjs.com/package/couchdb-dump) NPM module inorder to backup CouchDB databases

    # apt-get install nodejs-legacy npm
    # npm install -g couchdb-dump

### Setup Encryption

Generate the key

    # gpg --gen-key

Note: You may need to increase entropy in order to help the key to be generated
faster. You can do this on a separate terminal or ssh connection. In ubuntu:

    # apt-get install rng-tools

Edit /etc/default/rng-tools and have a line with `HRNGDEVICE=/dev/urandom`

    # /etc/init.d/rng-tools start


List the keys

    # gpg --list-keys

    pub   2048R/A39F74A9 2013-08-25
    uid                  info <info@email.com>
    sub   2048R/B2E8AC86 2013-08-25

Copy a public key: should be `A39F74A9` in these case, this will be used with
duplicity to encrypt and decrypt the backups.

### Custom Shell Script for Backup and Restore

#### configuration

    create a file named `.backup_config` to the home directory and make the
    necessary changes. You can copy example_config and edit accordingly.

        cp example_config ~/.backup_config

#### backup

    duplicity_backup mysql
    duplicity_backup postgres
    duplicity_backup mongo
    duplicity_backup couchdb
    duplicity_backup folder /path/to/target/folder file:///path/to/backup/target
    duplicity_backup folder /path/to/target/folder s3://BUCKET/target

#### restore

    duplicity_backup restore mysql /path/to/restore/folder
    duplicity_backup restore postgres /path/to/restore/folder
    duplicity_backup restore mongo /path/to/restore/folder
    duplicity_backup restore couchdb /path/to/restore/folder
    duplicity_backup restore folder file:///path/to/backup/target /path/to/restore/target
    duplicity_backup restore folder s3://BUCKET/target /path/to/restore/target

NOTE: you have to restore the actual database after this, if that is your intention.

`Mysql`:

    mysql -u USERNAME -p DB_NAME < /path/to/restore/folder/DB_NAME.sql

`Mongo`:

    mongorestore /path/to/restore/folder

`CouchDB`:

    gunzip /path/to/restored/file
    cdbload -d database_to_restore < /path/to/extracted/json