
         ____  _     ___ 
        / ___ | |   |_ _|
        | |   | |    | | 
        | |___| |___ | | 
        \____ |_____|___|
                        

## CLI commands basics

List all packages installed in our linux debian system:

    $ dpkg --get-selections 

Export all packages installed into a txt file:

    $ dpkg --get-selections > package.txt

Install packages from txt file:

    $ sudo dpkg --set-selections < packages.txt
