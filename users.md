
# Linux users

## useradd

For example to create a new user named username you would run:

    $ sudo useradd toni

When executed without any option, useradd creates a new user account using the default settings specified in the /etc/default/useradd file.
The command adds an entry to the /etc/passwd, /etc/shadow, /etc/group and /etc/gshadow files.
To be able to log in as the created user, you need to set the user password. To do that run the passwd command followed by the username:

    $ sudo passwd toni

Create a home directory

    $ sudo useradd -m toni

This command creates a new user's home directory with the same files from /etc/skel.

Create a specific home directory

    $ sudo useradd -m -d /home/toni toni

Create a user with a specific user ID

    $ sudo useradd -u 991 toni

By default when a user is created, the system assigns the next available UID from the range of user IDS specified in the login.defs file.

Create a user with a specific login shell

    $ sudo useradd -s /bin/bash toni

By default the new user's login shell is set as definded in /etc/default/useradd file.

> Source: https://linuxize.com/post/how-to-create-users-in-linux-using-the-useradd-command/