
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

Result after creating both vm's:
```shell
virsh list --all

 Id   Name     State
-------------------------
 -    node-1   shut off
 -    node-2   shut off
```

Corosync configuration

```shell
ha-node-1:~$ cat /etc/corosync/corosync.conf
totem {
    version: 2
    secauth: off
    cluster_name: my_cluster
    transport: udpu
}

nodelist {
    node {
        ring0_addr: 192.168.122.220
        nodeid: 1
    }
    node {
        ring0_addr: 192.168.122.222
        nodeid: 2
    }
}
quorum {
    provider: corosync_votequorum
}
```

```shell
ha-node-1:~$ sudo crm_mon

Cluster Summary:
  * Stack: corosync (Pacemaker is running)
  * Current DC: ha-node-2 (version 2.1.8-2.1.8) - partition with quorum
  * Last updated: Sat Feb 22 14:18:57 2025 on ha-node-1
  * Last change:  Fri Feb 21 21:20:51 2025 by hacluster via hacluster on ha-node-1
  * 2 nodes configured
  * 0 resource instances configured

Node List:
  * Online: [ ha-node-1 ha-node-2 ]

Active Resources:
  * No active resources
```