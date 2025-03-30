
# HA Cluster 

### Description

Pacemaker and Corosync are open-source tools that allow you to create a high-availability cluster on your Ubuntu servers. In this tutorial, I will guide you through the process of setting up a high-availability cluster using Pacemaker and Corosync on two Ubuntu VM servers. 

### Pacemaker

Pacemaker is a high-availability cluster resource manager – software that runs on a set of hosts (a cluster of
nodes) in order to preserve integrity and minimize downtime of desired services (resources).

Pacemaker's key features include:

- Detection of and recovery from node and service-level failures
- Ability to ensure data integrity by fencing faulty nodes
- Support (but no requirement) for shared storage
- Support for practically any redundancy configuration (active/passive, N+1, etc.)
- Automatically replicated configuration that can be updated from any node
- Ability to specify cluster-wide relationships between services, such as ordering, colocation, and anti-colocation
- Support for advanced service types, such as clones (services that need to be active on multiple nodes), promotable clones (clones that can run in one of two roles), and containerized services
- Unified, scriptable cluster management tools

#### Cluster Architecture

At a high level, a cluster can be viewed as having these parts (which together are often referred to as the
cluster stack):

- Resources: These are the reason for the cluster's being, the services that need to be kept highly
available.
- Resource agents: These are scripts or operating system components that start, stop, and monitor resources, given a set of resource parameters. These provide a uniform interface between Pacemaker and the managed services.
- Fence agents: These are scripts that execute node fencing actions, given a target and fence device parameters.
- Cluster membership layer: This component provides reliable messaging, membership, and quorum information about the cluster. Currently, Pacemaker supports Corosync as this layer.
- Cluster resource manager: Pacemaker provides the brain that processes and reacts to events that occur in the cluster. These events may include nodes joining or leaving the cluster; resource events caused by failures, maintenance, or scheduled activities; and other administrative actions. To achieve the desired availability, Pacemaker may start and stop resources and fence nodes.
- Cluster tools: These provide an interface for users to interact with the cluster. Various command-line and graphical (GUI) interfaces are available.

*The Cluster Information Base (CIB) is an XML representation of the cluster's configuration and the state of all nodes and resources. The CIB manager (pacemaker-based) keeps the CIB synchronized across the cluster, and handles requests to modify it.*

#### Fencing

Fencing protects your data from being corrupted, and your application from becoming unavailable, due to unintended concurrent access by rogue nodes.
Just because a node is unresponsive doesn't mean it has stopped accessing your data. The only way to be 100% sure that your data is safe, is to use fencing to ensure that the node is truly offline before allowing the data to be accessed from another node.

Fencing also has a role to play in the event that a clustered service cannot be stopped. In this case, the cluster uses fencing to force the whole node offline, thereby making it safe to start the service elsewhere. Fencing is also known as STONITH, an acronym for “Shoot The Other Node In The Head”, since the most popular form of fencing is cutting a host's power.

The two broad categories of fence device are power fencing, which cuts off power to the target, and fabric fencing, which cuts off the target’s access to some critical resource, such as a shared disk or access to the local network.
Power fencing devices include:
- Intelligent power switches
- IPMI
- Hardware watchdog device (alone, or in combination with shared storage used as a "poison pill" mechanism)

Fabric fencing devices include:
- Shared storage that can be cut off for a target host by another host (for example, an external storage device that supports SCSI-3 persistent reservations)
- Intelligent network switches

#### DRBD

Even if you're serving up static websites, having to manually synchronize the contents of that website to all the machines in the cluster is not ideal. For dynamic websites, such as a wiki, it's not even an option. Not everyone can afford network-attached storage, but somehow the data needs to be kept in sync.

*Enter DRBD, which can be thought of as network-based RAID-1.*

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