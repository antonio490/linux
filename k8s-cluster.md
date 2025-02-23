# k8s cluster 

### Description
This documents guides you through the creation of a kubernetes cluster using QEMU VMs.


virt-install \
  --name k8s-master \
  --ram 4096 \
  --vcpus 2 \
  --disk path=/var/lib/libvirt/images/k8s-master.qcow2,size=20 \
  --cdrom /home/antonio/virt/ISO/ubuntu-24.10-live-server-amd64.iso \
  --os-variant ubuntu24.10 \
  --import \
  --network bridge=virbr0

  virt-clone \
  --original k8s-master \
  --name k8s-worker-1 \
  --file /var/lib/libvirt/images/k8s-worker-1.qcow2

  virt-clone \
  --original k8s-master \
  --name k8s-worker-2 \
  --file /var/lib/libvirt/images/k8s-worker-2.qcow2