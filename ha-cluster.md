
# HA Cluster 

### Description

Pacemaker and Corosync are open-source tools that allow you to create a high-availability cluster on your Ubuntu servers. In this tutorial, I will guide you through the process of setting up a high-availability cluster using Pacemaker and Corosync on two Ubuntu VM servers. 

### Build & Installation

```shell
virt-install \
    --name node-1 \
    --memory 2048 \
    --vcpus 2 \
    --disk path=/var/lib/libvirt/images/node-1.qcow2,size=20 \
    --cdrom /home/antonio/virt/ISO/ubuntu-24.10-live-server-amd64.iso \
    --os-variant ubuntu24.10 \
    --network network=default \
    --graphics vnc \
    --console pty,target_type=serial \
    --import
```

Start the VM and install packages pacemaker and corosync:
```shell
sudo apt update
sudo apt install pacemaker corosync
```

Clone the node-1 vm to have a second node name node-2, which has already has pacemaker and corosync installed.
```shell
virt-clone \
    --original node-1 \
    --name node-2 \
    --file /var/lib/libvirt/images/node-2.qcow2
```

This is my result after creating both vm's:
```shell
virsh list --all

 Id   Name     State
-------------------------
 -    node-1   shut off
 -    node-2   shut off
```
