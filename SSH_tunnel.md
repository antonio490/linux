
## SSH Tunneling to access server ports

- Local port forwarding: Make remote resources accessible on your local system
   
    $ ssh -L local_port:remote_address:remote_port username@ip_dir

    $ ssh -L 8080:192.168.1.100:80 antonio@192.168.1.92

Let's say you have an SSH server running at port 22 on your office computer, but you also have a database server running at port 1234 on that same system at the same address. You want to access the database server from home, but the system is only accessible by SSH connections on port 22 and its firewall does not allow any other external connections.

    $ ssh -L 8888:localhost:1234 user@ip_direction

If you want to do the same as above but using a graphical interface such as Putty. you would enter 8888 as the source port and localhost:1234 as the destination.

![alt text](https://www.howtogeek.com/wp-content/uploads/2017/02/ximg_589a51d96fdd6.png.pagespeed.gp+jp+jw+pj+ws+js+rj+rp+rw+ri+cp+md.ic.p74vzQSYWE.png) 


- Remote port forwarding: Make local resources accessible on a remote system

    $ ssh -R remote_port:local_address:local_port username@ip_dir

    $ ssh -R 8888:localhost:1234 user@ip_dir

Someone could then connect to the SSH server at port 888 and that connection would be tunneled to the server application running at port 1234 on the local PC you established the connection from.