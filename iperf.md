# Iperf 
## Network bandwidth testing application

Iperf has two operation modes, client and server. The server runs on the remote host and listens for connections from the client. The client is where you calculate the bandwith test parameters and connect to a remote server.


### Installation (Ubuntu)

    $ apt-get install iperf

### Start server mode

    $ iperf -s

### Start server in daemon mode

    $ iperf -s -D

### Connecting with client

    $ iperf -c 172.22.14.221

### Bi-directional simultaneous (test the speed both ways at the same time)

    $ iperf -c 172.22.14.221 -d

 
### Bi-directional (test the speed both one after another)

    $ iperf -c 172.22.14.221 -r

### Change the window size

The TCP window size can be changed using the -w switch followed by the number of bytes to use. the below example shows a window size of 2KB. This can be used on either the server or the client.

    $ iperf -c 172.22.14.221 -w 2048

    $ iperf -s -w 2048

### Change the port

You must use the same port on both the client and the server for the two processes to communicate with each other. Use the -p switch followed by the port number to use on both the local and remote host.

    $ iperf -c 10.1.1.50 -p 9000

    $ iperf -s -p 9000

### Change the test duration

The default test duration of Iperf is 10 seconds. You can override the default with the -t switch followed by the time in seconds the test should last.

    $ iperf -s -t 60

### UDP instead of TCP

The default protocol for Iperf to use is TCP. You can change this to UDP with the -u switch. You will need to run both the client and server in UDP mode to perform the tests.

    $ iperf -s -u

    $ iperf -c -u

The result will have an extra metric for the packet loss which should be as low as possible, otherwise the packets will have to be re-transmitted using more bandwidth.

### Run multiple threads

    $ iperf -c -P 4

### Check the version of Iperf

    $ iperf -v

### Help

    $ iperf -h