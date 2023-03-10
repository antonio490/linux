# Linux Network Namespace

Linux network namespaces are a Linux kernel feature allowing us to isolate network environments through virtualization. Using network namespaces, you can create separate network interfaces and routing tables that are isolated from the rest of the system and operate independently.

* Linux namespaces are the basis of container technologies like Docker or Kubernates 

* Linux includes 6 types of namespaces: pid,net, uts, mnt, ipc, and user. 

With command `lsns` displays all existing namespaces in your system.

To create a network namespace in Linux:

    ip netns add <namespace_name>

Create a loopback interface for the namespace:

    ip netns exec <namespace_name> <command>

    ip netns exec <namespace_name> ip link set dev lo up

Check if loopback interface was added properly:

    ip netns exec <namespace_name> ip address

We can also ping the loopback interface inside the namespace:

    ip netns exec <namespace_name> ping 127.0.0.1

### Add a network interface to you namespace

Associate a hardware network card to your namespace, or you can add virtual network devices.

To create a virtual network ethernet device, run the following command, where enp2s0 si the new device and v-peer1 its arbitrary name:

    ip link add v-enp2s0 type veth peer name v-eth0

Now assign the virtual device to your namespace by running the command below:

    ip link set v-eth0 netns <namespace_name>

Assign an ip address to the network device as shown below:

    ip -n <namespace_name> addr add 10.0.1.0/24 dev v-eth0