

###############################################################
###################### netRules.sh ############################
###############################################################
### Establish mac address with interfaces in persistent way.###
###############################################################



#!bin/bash

FILE=/etc/udev/rules.d/70-persistent-net.rules

[ -e $FILE ] && rm $FILE

NUM=$(ifconfig | grep HW | wc -l)
START=1

for i in $( seq $START $NUM )
do
        MAC_ADDRESS=$(ifconfig | grep HW | sed -n ${i}p | awk '{print $5}')
        echo $MAC_ADDRESS
        ETH_NUM=$((i-1))
        echo $ETH_NUM
        echo "SUBSYSTEM==\"net\", ACTION==\"add\", DRIVERS==\"?*\", ATTR{address}==\"$MAC_ADDRESS\", ATTR{dev_id}==\"0x0\",ATTR{type}==\"1\", NAME=\"eth$ETH_NUM\"" >> /etc/udev/rules.d/70-persistent-net.rules
done
