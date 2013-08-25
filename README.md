Using duplicity - Encrypted incremental backup to local or remote storage.

Install duplicity and Dependecies

- ubuntu
    # apt-get install duplicity
- arch linux
    # pacman -S duplicity

If you are going to use Amazon S3 storage install boto
    # apt-get install python-pip
    # pip install boto
    
## Setup Encryption

- generate the key 
    gpg --gen-key

    Note: You may need to increase entropy in order to help the key to be generated
    faster. You can do this on a separate terminal or ssh connection. In ubuntu:
    
    # apt-get install rng-tools
    - Edit /etc/default/rng-tools and have a line with
        HRNGDEVICE=/dev/urandom
    # /etc/init.d/rng-tools start
    

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
