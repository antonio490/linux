# Policy Based Routing

- Policy routing tables: Linux has three by default: Local, Main and Default. Somewhat unintuitively, routes added to the system without a routing table specified go to the main table, not the default table.

- Policy routing rules: Linux comes with three rules, one for each of the default routing tables.

In order for us to leverage policy routing for our purposes, we need to do three things:

1. We need to create a custom policy routing table.

2. We need to create one or more custom policy routing tables.

3. We need to populate the custom policy routing table with routes.

### Create a custom Policy Routing Table

The first step is to create a custom policy routing table. Linux routing tables are identified by a number from 1 to 255, or by a name taken from the file `/etc/iproute2/rt_tables`. 

    echo 200 custom >> /etc/iproute2/rt_tables

This creates the table with the ID 200 and the name "custom". You'll reference this name later as you create the rules and populate the table with routes, so make note of it. Because this entry is contained in the `rt_table` file, it will be persistent across reboots.

### Creating Policy Routing Rules

The next step is to create the policy routing rules that will tell the system which table to use to detrmine the correct route.

Let's say that we wanted to create a rule that told the system to use the "custom" table we created earlier for all traffic originating from the source address `192.168.30.200`:

    ip rule add from 192.168.30.200 lookup custom

To list all of the rules

    ip rule list

Rules created this way disappear when the system is restarted. To make the rules persist, add a line like this to `/etc/network/interfaces` :

    post-up ip rule add from 192.168.30.200 lookup custom

With this line in place, the rule should persist across reboots or across network restart.

### Populating the Routing Table

Once we have the custom policy routing table created and a rule defined that directs the system to use it, we need to populate the table with the correct routes. The generic command to do this is the `ip route add` command, but with a specific `table` parameter added.

Using our previous example, let's say we wanted to add a default route that was specific to traffic originating from `192.168.30.200`
To add a new default route specifically for that interface, you'd use this command:

    ip route add default via 192.168.30.1 dev eth1 table custom

As with the policy routing tables, routes added this way are not persistent, so you'll want to make them persistent by adding a line like this to your `/etc/network/interfaces` configuration file:

    post-up ip route add default via 192.168.30.1 dev eth1 table custom

This will ensure that the appropriate routes are added to the policy routing table when the corresponding network interface is brought up.


