
# Linux Storage Administration

### Description
we will focus on managing storage in Linux systems. Learn about different storage types, file system creation, and mounting. Advanced topics like Logical Volume Management (LVM), filesystem hierarchy, and disk troubleshooting tp provide you with practical skills to manage Linux storage effectively.

#### Journaling
A journaling file system is a file system that keeps track of changes not yet committed to the file system's main part by recording the goal of such changes in a data structure known as a "journal", which is usually a circular log. In the event of a system crash or power failure, such file systems 
can be brought back online more quickly with a lower likelihood of becoming corrupted

Linux most common filesystems:
- ext{2,3,4}
- brtfs
- xfs

#### LVM

```shell
pvdisplay
vgdisplay
lgdisplay

pvcreate
vgcreate
lgcreate
```