
# Script tools

### AWK

<br>

Print just the first column:


    $ ps aux | awk '{print $1}'


Change field separator:

    $ awk BEGIN'{FS=":"} ; {print $1}' /etc/passwd


Print with format:

    $ awk BEGIN'{FS=":"} ; {printf "%s\t %s\n", $1, $7}' /etc/passwd



### SED

### CUT

### TR


