# Policy Based Routing

- Policy routing tables: Linux has three by default: Local, Main and Default. Somewhat unintuitively, routes added to the system without a routing table specified go to the main table, not the default table.

- Policy routing rules: Linux comes with three rules, one for each of the default routing tables.

In order for us to leverage policy routing for our purposes, we need to do three things:

1. We need to create a custom policy routing table.

2. We need to create one or more custom policy routing tables.

3. We need to populate the custom policy routing table with routes.

### Create a custom Policy Routing Table

The first step is to create a custom policy routing table. Linux routing tables are identified by a number from 1 to 255, or by a name taken from the file /etc/iproute2/rt_tables. 

    echo 200 custom >> /etc/iproute2/rt_tables

This creates the table with the ID 200 and the name "custom". You'll reference this name later as you create the rules and populate the table with routes, so make note of it. Because this entry is contained in the rt_table file, it will be persistent across reboots.