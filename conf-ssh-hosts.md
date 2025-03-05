# SSH keys 

### Description
Basic guide to configure ssh between hosts.

Generate public/private ssh keys

```shell
ssh-keygen

>ll ~/.ssh/

-rw-------  1 xyz xyz  2602 feb  6  2021 id_rsa
-rw-r--r--  1 xyz xyz   573 feb  6  2021 id_rsa.pub

```

Copy the public key using command:
```shell
ssh-copy-id user@<server-ip-address>
```
Adapt ssh configuration for certificate authentication

```shell
sudoedit /etc/ssh/sshd_config.d/local.conf

PasswordAuthentication no
```