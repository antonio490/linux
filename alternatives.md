# Chnage from default to alternative version in python

To change python version system-wide we can use update-alternatives command. Logged in as a root user, first list all available python alternatives: 

<code>

    # update-alternatives --list python
    update-alternatives: error: no alternatives for python
</code>

The above error message means that no python alternatives has been recognized by update-alternatives command. For this reason we need to update our alternatives table and include both python2.7 and python3.4: 

<code>

    # update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1
    update-alternatives: using /usr/bin/python2.7 to provide /usr/bin/python (python) in auto mode

    # update-alternatives --install /usr/bin/python python /usr/bin/python3.4 2
    update-alternatives: using /usr/bin/python3.4 to provide /usr/bin/python (python) in auto mode

</code>

Next, we can again list all python alternatives:

> \# update-alternatives --list python <br>
> /usr/bin/python2.7 <br>
> /usr/bin/python3.4

