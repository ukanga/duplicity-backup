Using duplicity - Encrypted incremental backup to local or remote storage.
 
## Setup Encryption

- generate the key 
    gpg --gen-key
- list the keys
    gpg --list-keys
    
    pub   2048R/A39F74A9 2013-08-25
    uid                  info <info@email.com>   
    sub   2048R/B2E8AC86 2013-08-25


- copy a public key: should be `A39F74A9` in these case, this will be used with
duplicity to encrypt and decrypt the backups.

## Custom Shell Script for Backup and Restore

- configuration

    create a file named `.backup_config` to the home directory and make the
    necessary changes. You can copy example_config and edit accordingly.

    cp example_config ~/.backup_config
    
- backup

    duplicity_backup mysql
    duplicity_backup mongo

- restore
    
    duplicity_backup restore mysql
    duplicity_backup restore mongo
