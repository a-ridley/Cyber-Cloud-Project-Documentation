---
id: openstack-tutorial
title: Openstack Tutorial
slug: /
---

Your account for OpenStack is ready!

Once you are connected to the VPN visit the cloud here: http://10.40.216.102:5000/dashboard/

You'll be able to log in with credentials (*username*, *pasword*) you'll want to reset your password after you log on.

At the top right select your username and then click settings. On your left is the context menu, on the context menu under settings select change password.

At the top left next to the CCP icon, you'll see a list of your domains and projects, you can switch freely between them. Currently you are a member of the &ltproject&lrt project.

In the context menu you can select Projects > Compute > Instances. You'll see an overview of all your instances. If there is one available to you, connect to it using root/root. If one is not available, the following steps will guide you to create a new VM.

Create a new instance by selecting "Launch Instance" the settings for each tab are:

Details: specify a name, and how many vms

Source: Create new volume should be NO, select your OS from the list.

Flavor: Select your image size (remember to meet the minimum specs for your OS)

Networks: Select the Provider network to grant internet access to your VMs.

The rest of the settings should be left alone.

When you complete the instance the dialog box will close and a new vm will appear in the list. If it doesn't refresh the page. Select the name and you'll see more detailed information.

Once your image is done building you can click on the instance name. Select the console tab to view your VM. You can connect to your server using "root/root" for centos, ubuntu.

Email at mcampos@sandiego.edu or abigailcastro@sandiego.edu for more help.