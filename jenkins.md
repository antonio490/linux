
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


### Configure SSH keys

```shell
ssh-keygen -t rsa -b 4096 -C "server-vm" -f ~/.ssh/server_vm_key
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/antonio/.ssh/server_vm_key
Your public key has been saved in /home/antonio/.ssh/server_vm_key.pub
The key fingerprint is:
SHA256:yJRJTltisX3Iwq6AB3XlQTqdSIkuWglRGnM7aV/+KL0 server-vm
The key's randomart image is:
+---[RSA 4096]----+
|+o+.o+X..        |
|.*.=.@ % .       |
|oo=.+ # + .      |
|.++o B o .       |
|ooo . = S        |
|.. . o o         |
|    o o .        |
|     . .         |
|      E          |
+----[SHA256]-----+
```

```shell
ssh-copy-id -i ~/.ssh/server_vm_key.pub ans@192.168.122.87

/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/antonio/.ssh/server_vm_key.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
ans@192.168.122.87's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'ans@192.168.122.87'"
and check to make sure that only the key(s) you wanted were added.
```

On the server VM, ensure SSH is configured properly:
```shell
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
sudo systemctl restart ssh
```

Install java

```shell
sudo apt install -y openjdk-11-jdk
```


Download jenkins.war

```shell
wget https://get.jenkins.io/war-stable/2.332.3/jenkins.war
```

Configure jenkins systemd

```shell
sudo cp jenkins.war /usr/share/java/jenkins.war 
sudo vi /lib/systemd/system/jenkins.service

-----------------------------------------------------
# Directory where Jenkins stores its configuration and workspaces
Environment="JENKINS_HOME=/var/lib/jenkins"
WorkingDirectory=/var/lib/jenkins

# Location of the Jenkins WAR
Environment="JENKINS_WAR=/usr/share/java/jenkins.war"

# Location of the exploded WAR
#Environment="JENKINS_WEBROOT=%C/jenkins/war"
```

Start jenkins

```shell

sudo systemctl enable jenkins.service
sudo systemctl start jenkins.service

ss -tulpn | grep 8080
tcp   LISTEN 0      50                 *:8080            *:* 
```

Troubleshoot

Make sure java latest version is installed, otherwise there could be incompatibilities with jenkins:

```shell
java --version
openjdk 21.0.6 2025-01-21
OpenJDK Runtime Environment (build 21.0.6+7-Ubuntu-124.10.1)
OpenJDK 64-Bit Server VM (build 21.0.6+7-Ubuntu-124.10.1, mixed mode, sharing)
```