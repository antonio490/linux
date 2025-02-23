# k8s cluster 

### Description
This documents guides you through the creation of a kubernetes cluster using QEMU VMs.


First we deploy a vm for the master node named k8s-master.

```shell
virt-install \
  --name k8s-master \
  --ram 4096 \
  --vcpus 2 \
  --disk path=/var/lib/libvirt/images/k8s-master.qcow2,size=20 \
  --cdrom /home/antonio/virt/ISO/ubuntu-24.10-live-server-amd64.iso \
  --os-variant ubuntu24.10 \
  --import \
  --network bridge=virbr0

```
Intall a container runtime, here we install docker:

```shell
sudo apt install -y containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd
```

Next we install the kubernetes components kubelet, kubeadm and lubectl:

```shell
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo systemctl enable kubelet
```

No using the virt-clone called we deploy two additional vm`s for the worker nodes:

```shell
  virt-clone \
  --original k8s-master \
  --name k8s-worker-1 \
  --file /var/lib/libvirt/images/k8s-worker-1.qcow2

  virt-clone \
  --original k8s-master \
  --name k8s-worker-2 \
  --file /var/lib/libvirt/images/k8s-worker-2.qcow2
  ```
