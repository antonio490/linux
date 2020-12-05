
# GPG

## OpenPGP encryption and signing tool

> Date: 05/12/2020

### List all keys store on our machine

    $ gpg --list-keys

### Export gpg keys on ASCII format

    $ gpg --output public.pgp --armor --export username@email

    $ gpg --output private.pgp --armor --export-secret-key username@email

### Import gpg keys

    $ gpg --import public.pgp

    $ gpg --allow-secret-key-import private.pgp

### Modify gpg keys

    $ gpg --edit-key username@email

The application will then ask the level of trust we want to set on our key.
