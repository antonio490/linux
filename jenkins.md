
# Jenkins VM 

### Description
This documents guides you through the creation of a virtual server and afterwards the installation of jenkins.

Deploy a vm with ubuntu 24.10, 4G of RAM, 2 vcpus and 20G of disk space:

```shell
virt-install \
  --name server \
  --ram 4096 \
  --vcpus 2 \
  --disk path=/var/lib/libvirt/images/server.qcow2,size=20 \
  --cdrom /home/antonio/virt/ISO/ubuntu-24.10-live-server-amd64.iso \
  --os-variant ubuntu24.10 \
  --import \
  --network bridge=virbr0
```



