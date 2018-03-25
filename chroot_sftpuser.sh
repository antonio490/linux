# chroot_sftpuser.sh creates an internal sftp user with rsa login keys and a chroot directory. 

#!/bin/sh

# Install open-ssh
sudo apt-get install open-ssh

# Login to server with a ssh user
ssh [root-user]@[ip-ssh-server]

# Create user group
groupadd [group name]

# create user
useradd -g [group name] -d [directory path] [username]

# Generate rsa keys
mkdir ~/.ssh
chmod 700 ~/.ssh
ssh-keygen -t rsa

# Edit configuration file /etc/ssh/sshd_config
sudo mcedit /etc/ssh/sshd_config

# We need to comment this line:
Subsystem sftp /usr/lib/openssh/sftp-server

# We need to add this:
Subsystem sftp internal-sftp
Match Group [group name]
    ChrootDirectory [directory path]
    ForceCommand internal-sftp
    AllowTcpForwarding no

# Apply root permission to the directory you want to jailed
sudo chmod 755 [directory path]
sudo chown root:[group name] [directory path]

# Restart
sudo service sshd Restart

