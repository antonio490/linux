
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
sudo apt install pacemaker corosync coccinelle

sudo apt install git build-essential dkms linux-headers-$(uname -r)
```
```shell
git clone https://github.com/LINBIT/drbd.git
cd drbd
make
sudo make install
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

### Corosync installation and configuration

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

### DRBD installation and configuration

First we create a new virtual disk vdb and then we attach it to the correspondant vm:

```shell
qemu-img create -f qcow2 /var/lib/libvirt/images/node-1-vdb.qcow2 4G
virsh attach-disk node-1 /var/lib/libvirt/images/node-1-vdb.qcow2 vdb --persistent --subdriver=qcow2

qemu-img create -f qcow2 /var/lib/libvirt/images/node-2-vdb.qcow2 4G
virsh attach-disk node-2 /var/lib/libvirt/images/node-2-vdb.qcow2 vdb --persistent --subdriver=qcow2
```

```shell
ha-node-1:~$ lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
vda                       253:0    0   20G  0 disk 
├─vda1                    253:1    0    1M  0 part 
├─vda2                    253:2    0  1.8G  0 part /boot
└─vda3                    253:3    0 18.2G  0 part 
  └─ubuntu--vg-ubuntu--lv 252:0    0   10G  0 lvm  /
vdb                       253:16   0    4G  0 disk 
└─drbd0                   147:0    0    4G  1 disk 
```

Load drbd kernel module:

```shell
ha-node-1:~$ sudo modprobe drbd

ha-node-1:~$ lsmod | grep drbd
drbd                  462848  4
lru_cache              16384  1 drbd
libcrc32c              12288  3 btrfs,drbd,raid456
```

Start and check status of drbd:
```shell
sudo systemctl enable drbd
sudo systemctl start drbd

ha-node-1:~$ sudo systemctl status drbd
● drbd.service - DRBD -- please disable. Unless you are NOT using a cluster manager.
     Loaded: loaded (/usr/lib/systemd/system/drbd.service; enabled; preset: enabled)
     Active: active (exited) since Sat 2025-02-22 14:18:23 UTC; 5h 58min ago
 Invocation: 66da37ebad6743f0b8a6f37eb6a30dfd
    Process: 933 ExecStart=/lib/drbd/scripts/drbd start (code=exited, status=0/SUCCESS)
   Main PID: 933 (code=exited, status=0/SUCCESS)
   Mem peak: 3M
        CPU: 51ms

Feb 22 14:15:29 ha-node-1 drbd[933]: /lib/drbd/scripts/drbd: line 148: /var/lib/linstor/loop_device_mapping: No such file or directory
Feb 22 14:15:29 ha-node-1 drbd[955]: [
Feb 22 14:15:29 ha-node-1 drbd[955]:      create res: store
Feb 22 14:15:29 ha-node-1 drbd[955]:    prepare disk: store
Feb 22 14:15:29 ha-node-1 drbd[955]:     adjust disk: store
Feb 22 14:15:29 ha-node-1 drbd[955]:      adjust net: store
Feb 22 14:15:29 ha-node-1 drbd[955]: ]
Feb 22 14:18:23 ha-node-1 drbd[985]: WARN: stdin/stdout is not a TTY; using /dev/console
Feb 22 14:18:23 ha-node-1 drbd[933]:    ...done.
Feb 22 14:18:23 ha-node-1 systemd[1]: Finished drbd.service - DRBD -- please disable. Unless you are NOT using a cluster manager..
```

```shell
ha-node-1:~$ cat /etc/drbd.d/store.res 
resource store {      
   device /dev/drbd0;      
   disk /dev/vdb;      
   meta-disk internal;      
   on ha-node-1 {          
      address 192.168.122.220:7788;          
   }      
   on ha-node-2 {          
      address 192.168.122.222:7788;          
   }      
}
```

```shell
sudo drbdadm create-md store
sudo drbdadm up store
sudo drbdadm primary --force store
```

```shell
ha-node-1:~$ drbdadm status
store role:Primary
  disk:UpToDate
  peer role:Secondary
    replication:Established peer-disk:UpToDate
```

```shell
antonio@ha-node-2:~$ drbdadm status
store role:Secondary
  disk:UpToDate
  peer role:Primary
    replication:Established peer-disk:UpToDate
```

```shell
ha-node-1:~$ sudo mkfs.ext4 /dev/drbd0
mke2fs 1.47.1 (20-May-2024)
/dev/drbd0 contains a ext4 file system
	created on Fri Feb 21 21:18:35 2025
Proceed anyway? (y,N) y
Discarding device blocks: done                            
Creating filesystem with 1048535 4k blocks and 262144 inodes
Filesystem UUID: d4f5bf7c-c23f-4e94-9a93-a1e354ad0007
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376, 294912, 819200, 884736

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done 

ha-node-1:~$ sudo mount /dev/drbd0 /mnt/store/

ha-node-1:~$ lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
vda                       253:0    0   20G  0 disk 
├─vda1                    253:1    0    1M  0 part 
├─vda2                    253:2    0  1.8G  0 part /boot
└─vda3                    253:3    0 18.2G  0 part 
  └─ubuntu--vg-ubuntu--lv 252:0    0   10G  0 lvm  /
vdb                       253:16   0    4G  0 disk 
└─drbd0                   147:0    0    4G  0 disk /mnt/store
```