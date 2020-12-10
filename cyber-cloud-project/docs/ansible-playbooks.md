---
id: ansibleplaybooks
title: Ansible Playbooks
---

# Ansible Playbooks
## Overview
The primary objective of the ansible playbooks is to convert all our existing manual steps into a documented and automated process. 

0. Review the Ansible documentation to understand the basic structure of the project (https://docs.ansible.com/ansible/latest/user_guide/playbooks.html)
1. Connect to the logging server.
2. Change your directory to the folder `/home/playbooks/`
    - Makefile: contains commands related to building or running automated processes. This is the entrypoint you will be interacting with as an enduser, more on this later.
    - ansible.cfg: configuration settings for ansible.
    - cluster.yaml: configuration settings for playbook, it describes which roles are assigned to which hosts. You can find roles in the `/roles` folder, and hosts in the `inventory` file.
    - inventory: describes the hosts and computers used to build the openstack cluster.
    - group_vars/: a folder which contains secrets for building our openstack platform. **This file is not provided by default; a proper cluster will not be built without this file**
3. Run `make ping` to verify that you can connect to all the hosts.
4. Verify your settings in the `group_vars/` folder.
5. Run `make cluster`
7. Connect to the dashboard using the information provided at the end of the make script (if you closed the ansible-playbook process detailed logs of the last attempt are kept in the `.logs/` folder)
8. Optionally: verify your installation by running the test scripts deployed on the controller: `/home/infrastructure_tests/`

## Detailed Descriptions
### Makefile
Example commands and their effects.
1. `make update` - updates the ansible-playbook scripts.
2. `make cluster` - builds the openstack cluster.
3. `make ping` - checks all hosts to see if they are pingable.
4. `make startup` - runs the startup.sh script across all hosts.
### Inventory File
In the inventory file we see a detailed decription of our hosts.
example inventory item: `compute1 ansible_host=10.10.10.11 provider_network_ip=192.168.128.11 physical_interface=em1` 
1. ansible_host: must be the management IP for the host, this IP must be on a network that connects all openstack servers together.
2. provider_network_ip: the provider network IP for the host, this is the IP that provides an internet connection to the machine.
3. physical_interface: the network interface that for the management IP of the host.
### group_vars Folder
This file is critical to the deployment of the openstack cluster. It contains all of the secrets such as service passwords; it also contains configuration information such as management network subnet, or package files.

This file is kept hidden and is not part of the OpenStack deployer repository, please reach out to a system administrator if you need access to the file.
