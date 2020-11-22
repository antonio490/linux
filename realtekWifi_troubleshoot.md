
# Realtek wifi adapter

How to fix realtek linux driver.


    $ sudo lshw -class network

    *-network
        description: Wireless interface
        product: RTL8723BE PCIe Wireless Network Adapter
        vendor: Realtek Semiconductor Co., Ltd.'



The problems is that wifi suddenly turns of or it reduces the signal power. It is recommended
to change two values on the following configuration files:



    $ sudo nano /etc/pam/sleep.d/config

    > SUSPEND_MODULES= "RTL8723BE"


    $ echo "options RTL8723BE fwlps=N" | sudo tee /etc/modprobe.d/RTL8723BE.conf

    $ echo "options RTL8723BE fwlps=N" | sudo tee /etc/modprobe.d/rtl8723BE.conf



Lastly reboot the system.
