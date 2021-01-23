---
id: ansible-playbooks
title: Ansible Playbooks
---

## Overview
The primary objective of the ansible playbooks is to convert all our existing manual steps into a documented and automated process. 

0. Review the Ansible documentation to understand the basic structure of the project (https://docs.ansible.com/ansible/latest/user_guide/playbooks.html)
1. Connect to the logging server.
2. Change your directory to the folder `/home/playbooks/`
    - Makefile: contains commands related to building or running automated processes. This is the entrypoint you will be interacting with as an enduser, more on this later.
    - ansible.cfg: configuration settings for ansible.
    - cluster.yaml: configuration settings for playbook, it describes which roles are assigned to which hosts. You can find roles in the `/roles` folder, and hosts in the `inventory` file.
    - inventory: describes the hosts and computers used to build the openstack cluster. There are two inventory files, test.inventory and prod.inventory. When targeting production, the correct inventory file must be used. See steps below for an example.
    - group_vars/: a folder which contains secrets for building our openstack platform. **This file is not provided by default; a proper cluster will not be built without this file**
3. Run `make ping` to verify that you can connect to all the hosts.
4. Verify your settings in the `group_vars/` folder.

:::important


Server kernel's should be manually upgraded prior to execution of step 5 using the following command: 

`yum update -y && yum upgrade -y`

:::

5. Run `make cluster` (without specifying the inventory file, the make cluster command will build using the test inventory file.)
7. Connect to the dashboard using the information provided at the end of the make script (if you closed the ansible-playbook process detailed logs of the last attempt are kept in the `.logs/` folder)
8. Optionally: verify your installation by running the test scripts found in the playbooks: `/home/playbooks/roles/controller/files/tests`
    - These scripts can be run manually by copy pasting the contents into the terminal of the controller or tcontroller host.

## Detailed Descriptions
### Makefile
#### Commands
Example commands and their effects.
1. `make update` - updates the ansible-playbook scripts.
2. `make cluster` - builds the openstack cluster.
3. `make ping` - checks all hosts to see if they are pingable.
4. `make startup` - runs the startup.sh script across all hosts.
5. `make scripts` - deploys custom scripts such as the classroom builder onto the host.

:::warning

In order to properly teardown block you need to manually wipe the drives before proceeding.

:::

6. `make teardown` - **destroys the current envrionment and resets it**.
7. `make logging` - deploys custom logging services onto the logging server, compute, and controller.
#### Variables
0. Replace the variables of a makefile by specifying them next to the command: 
    - `make ping INVENTORY=prod.inventory`
    - `make update BRANCH=backup`
    - `make cluster SKIP=common,block`
1. `BRANCH=` this variable specifies where to update the local code for. 
    - default: "main" the main branch from github/gitea
    - ex: "backup" can be used if you want to restore from a different branch on github/gitea
2. `SKIP=` a csv of the tags to skip in a playbook.
    - ex: "compute,controller,block" would skip all of the steps in the playbooks with matching tags
    - ex: "common" skips all the basic setup.
3. `INVENTORY=` the inventory file to run playbooks against. For more information about inventory files look at the section "Inventory File"
    - ex: "test.inventory"
    - ex: "prod.inventory"
### Inventory File
In the inventory file we see a detailed decription of our hosts.
example inventory item: `compute1 ansible_host=10.10.10.11 provider_network_ip=192.168.128.11 physical_interface=em1` 
1. ansible_host: must be the management IP for the host, this IP must be on a network that connects all openstack servers together.
2. provider_network_ip: the provider network IP for the host, this is the IP that provides an internet connection to the machine.
3. physical_interface: the network interface that for the provider IP of the host.
### group_vars Folder
This file is critical to the deployment of the openstack cluster. It contains all of the secrets such as service passwords; it also contains configuration information such as management network subnet, or package files.

This file is kept hidden and is not part of the OpenStack deployer repository, please reach out to a system administrator if you need access to the file.
### Roles Folder
1. Roles are assigned to each host using a combination of the inventory and cluster.yaml files. For more information on how these files work please visit the Ansible documentation.
2. The important roles are: controller, common, compute, and block
#### Common Role
1. Any shared/common task such as updates, or changing the host name that should occur on every host is added to the common role. 
#### Controller Role
1. All tasks related to spinning up a single controller node. Installs services such as: Keystone, glance, cinder, placement, nova, neutron, and more.
2. The controller role will also add the admin.sh and startup.sh scripts which are critical for administration of the server.
#### Compute Role/Block Role
1. Self explanitory, tasks related to compute and blocks nodes.
### Utils Folder
1. Stand alone tasks (run outside of roles/playbooks) and patches are added to this folder.