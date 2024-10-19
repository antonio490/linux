

sudo virt-install \
  --name=vm_name \
  --vcpus=2 \
  --memory=2048 \
  --disk size=20 \
  --cdrom=/path/to/iso/file.iso \
  --os-variant=ubuntu20.04 \
  --network network=default \
  --graphics spice


$ antonio (~) >sudo virsh net-list --all
 Name              State      Autostart   Persistent
------------------------------------------------------
 default           inactive   no          yes
 vagrant-libvirt   inactive   no          yes
 virtual-lab0      inactive   no          yes

$ antonio (~) >sudo virsh net-start default
Network default started

$ antonio (~) >sudo virsh net-list --all
 Name              State      Autostart   Persistent
------------------------------------------------------
 default           active     no          yes
 vagrant-libvirt   inactive   no          yes
 virtual-lab0      inactive   no          yes


$ antonio (~) >sudo virsh shutdown leap_micro

$ antonio (~) >sudo virsh destroy leap_micro

$ antonio (~) >sudo virsh undefine leap_micro


virt-install \
    --name=leap_micro \
    --osinfo=opensuse15.5 \
    --vcpus=2 \
    --memory=2048 \
    --disk size=15 \
    --cdrom=/home/antonio/VIRT/openSUSE-Leap-Micro.x86_64-Default-SelfInstall.iso \
    --network network=default,model=virtio



$ antonio (~) >sudo virsh list
 Id   Name         State
----------------------------
 5    leap_micro   running


$ antonio (~) >virsh dominfo leap_micro
Id:             5
Name:           leap_micro
UUID:           aaff400f-c38e-4fb9-b462-0310819f9ed1
OS Type:        hvm
State:          running
CPU(s):         2
CPU time:       135,7s
Max memory:     2097152 KiB
Used memory:    2097152 KiB
Persistent:     yes
Autostart:      disable
Managed save:   no
Security model: apparmor
Security DOI:   0
Security label: libvirt-aaff400f-c38e-4fb9-b462-0310819f9ed1 (enforcing)

$ antonio (~) >sudo virsh start leap_micro
Domain 'leap_micro' started

$ antonio (~) >sudo virsh list
 Id   Name         State
----------------------------
 7    leap_micro   running

$ antonio (~) >virt-viewer leap_micro
