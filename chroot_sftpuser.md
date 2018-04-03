
### chroot_sftpuser.sh creates an internal sftp user with rsa login keys and a chroot directory. 

<br>

 Install open-ssh

<code> sudo apt-get install open-ssh </code>

 Login to server with a ssh user

<code> ssh [root-user]@[ip-ssh-server] </code>

 Create user group

<code> groupadd [group name] </code>

 create user

<code>useradd -g [group name] -d [directory path] [username] </code>

 Generate rsa keys

mkdir ~/.ssh
chmod 700 ~/.ssh
ssh-keygen -t rsa

 Edit configuration file /etc/ssh/sshd_config

<code> sudo mcedit /etc/ssh/sshd_config</code>

 We need to comment this line:

    Subsystem sftp /usr/lib/openssh/sftp-server

 And add this at the end:

    Subsystem sftp internal-sftp
    Match Group [group name]
        ChrootDirectory [directory path]
        ForceCommand internal-sftp
        AllowTcpForwarding no

 Apply root permission to the directory you want to jailed
 
<code> sudo chmod 755 [directory path] </code>
<code> sudo chown root:[group name] [directory path] </code>

 Restart

<code> sudo service sshd Restart</code>

### Authorization logs

> /var/log/auth.log

### Group and users in ubuntu

> /etc/group
> /etc/passwd

### Helpful links
(https://www.digitalocean.com/community/tutorials/how-to-use-sftp-to-securely-transfer-files-with-a-remote-server)

(https://kb.iu.edu/d/aews)

(https://serverfault.com/questions/584986/bad-ownership-or-modes-for-chroot-directory-component)

(https://www.thegeekstuff.com/2012/03/chroot-sftp-setup/)
