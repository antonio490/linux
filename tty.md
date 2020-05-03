
         _   _         
        | |_| |_ _   _ 
        | __| __| | | |
        | |_| |_| |_| |
        \__|\__|\__, |
                |___/ 


## Teletype - tty

In Linux, there is a pseudo-teletype multiplexor which handles the connections from all of the terminal window pseudo-teletypes (PTS). The multiplexor is the master, and the PTS are the slaves. The multiplexor is addressed by the kernel through the device file located at /dev/ptmx.

The tty command will print the name of the device file that your pseudo-teletype slave is using to interface to the master. And that, effectively, is the number of your terminal window.


    antonio (master) linux $ tty
    /dev/pts/0


    antonio (master) linux $ tty -s && echo "Hello tty"
    Hello tty


### How to change tty terminal

You can access a full-screen TTY session by holding down the <kbd>Ctrl</kbd>+<kbd>Alt</kbd> keys, and pressing one of the function keys.

<kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>F3</kbd> will bring up the login prompt of tty3.

To get back to your graphical desktop environment, press <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>F2</kbd>

Pressing <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>F1</kbd> will return you to the login prompt of your graphical desktop session.


### CLI

Instead of using the keyboard shortcut we can also change virtual terminals on cli typing the next commands:

        $ chvt <terminal #>

        $ chvt 2 // Desktop tty

        $ chvt 3 // tty 3

### When can tty be useful?

- If we have to move a lot of data from directories instead of doing it on the Desktop tty it might be a good idea to do it on tty 3 for example so the action is executed faster.

- If computer freezes we should open a tty and try to stop programms running or reboot the computer on a safely way.


