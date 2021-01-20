---
id: compute-node-playbook
title: Playbook for Compute Nodes
---

:::caution

This is a raw script please look at the Ansible Guide to gain an overall understanding of the playbooks which affect all nodes.

:::

## Notes
https://docs.openstack.org/install-guide/openstack-services.html#minimal-deployment-for-train

Unfortnately, it's a manual process at the moment...

Executing this playbook by hand is pretty simple. Follow the steps and notes as outlined,

Before starting this playbook, copy it to another file and change the variables inside of angled brackets <variable_name_reference> with the correct variable.

While executing the playbook, don't forget to backup all the original files and copy over all the contents from the playbook onto a new file.

## Playbook
### Packages
```
yum update -y && yum upgrade -y
yum install centos-release-openstack-train -y
yum install python-openstackclient -y
yum install openstack-selinux -y
yum install openstack-nova-compute -y
yum install openstack-neutron-linuxbridge -y
yum install ebtables -y 
yum install ipset -y
yum install chrony -y
```
### Firewall
```
sudo firewall-cmd --permanent --add-service=ntp
sudo firewall-cmd --reload
```
### Environment
#### sudo vi /etc/hosts
```
10.10.10.11  compute1.usdcyber.edu    compute1
10.10.10.12  logging.usdcyber.edu     logging
10.10.10.13  object1.usdcyber.edu     object1
10.10.10.14  block1.usdcyber.edu      block1
10.10.10.16  compute4.usdcyber.edu    compute4
10.10.10.17  compute3.usdcyber.edu    compute3
10.10.10.18  controller.usdcyber.edu  controller
10.10.10.19  compute5.usdcyber.edu    compute5
10.10.10.26  compute4.usdcyber.edu    compute4
```
#### vi /etc/chrony.conf
```
server controller iburst
systemctl restart chronyd
```
### Nova
### openstack
#### vi /etc/nova/nova.conf
[DEFAULT]
enabled_apis = osapi_compute,metadata
transport_url = rabbit://openstack:<RABITMQ_PASSWORD>@controller
my_ip = <COMPUTE_NODE_MANAGEMENT_IP>
use_neutron = true
firewall_driver = nova.virt.firewall.NoopFirewallDriver
block_device_allocate_retries = 600
block_device_allocate_retries_interval = 10
block_device_creation_timeout = 300
instances_path=$state_path/instances
networks_path=$state_path/networks
state_path=/home/nova
vif_plugging_is_fatal=false
vif_plugging_timeout=0

[libvrt]
nfs_mount_point_base=$state_path/mnt
quobyte_mount_point_base=$state_path/mnt
smbfs_mount_point_base=$state_path/mnt
vzstorage_mount_point_base=$state_path/mnt

[zvm]
image_tmp_path=$state_path/images

[api]
auth_strategy = keystone

[cinder]
os_region_name = RegionOne

[keystone_authtoken]
www_authenticate_uri = http://controller:5000/
auth_url = http://controller:5000/
memcached_servers = controller:11211
auth_type = password
project_domain_name=Default
user_domain_name=Default
project_name=service
username=nova
password=<NOVA_USER_PASSWORD>

[vnc]
vnc_enabled=true
enabled=true
server_listen= $my_ip
server_proxyclient_address=$my_ip
novncproxy_base_url=http://10.40.216.102:6080/vnc_auto.html
novncproxy_host=10.40.216.102
novncproxy_port=6080

[glance]
api_servers = http://controller:9292

[oslo_concurrency]
lock_path = /var/lib/nova/tmp

[placement]
region_name = RegionOne
project_domain_name = Default
project_name = service
auth_type = password
user_domain_name = Default
auth_url = http://controller:5000/v3
username = placement
password = <PLACEMENT_USER_PASSWORD>

[neutron]
www_authenticate_uri = http://controller:5000
auth_url = http://controller:5000
memcached_servers = controller:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = neutron
password = <NEUTRON_USER_PASSWORD>

#### COMPLETE STEPS IN NOTES:
create a new folder in /home called nova, the path should be /home/nova
then copy all the contents over from /etc/lib/nova/ into home/nova. `cp -r /var/lib/nova/ /home/`

update /etc/nova/nova.conf in the compute node and set it's state_path variable to point to /home/nova/nova (or /home/nova)
any keys that reference $state_path should be uncommented.


reboot the nova services on the controller node.
reboot the nova services on compute node
##### grant nova user permission to the folder:
chown -R nova /home/nova 
chgrp -R nova /home/nova
##### set SEL Linux permissions: 
semanage fcontext -a -t nova_var_lib_t '/home/nova(/.*)?'
restorecon -vvRF /home/nova/
#### post
egrep -c '(vmx|svm)' /proc/cpuinfo
systemctl enable libvirtd.service 
systemctl enable openstack-nova-compute.service
systemctl start libvirtd.service 
systemctl start openstack-nova-compute.service


## Neutron
### sudo vi /etc/neutron/neutron.conf
[DEFAULT]
transport_url = rabbit://openstack:<RABBITMQ_PASSWORD>@controller
auth_strategy = keystone

[keystone_authtoken]
www_authenticate_uri = http://controller:5000
auth_url = http://controller:5000
memcached_servers = controller:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = neutron
password = <NEUTRON_USER_PASSWORD>

[oslo_concurrency]
lock_path = /var/lib/neutron/tmp

### sudo vi /etc/neutron/plugins/ml2/linuxbridge_agent.ini
[linux_bridge]
physical_interface_mappings = provider:<COMPUTE_HOST_PROVIDER_NETWORK_INTERFACE>

[vxlan]
enable_vxlan = true
local_ip = <COMPUTE_HOST_MANAGEMENT_IP>
l2_population = true

[securitygroup]
enable_security_group = true
firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver

### post
modprobe br_netfilter
sysctl -p
sysctl net.bridge.bridge-nf-call-iptables
sysctl net.bridge.bridge-nf-call-ip6tables
systemctl restart openstack-nova-compute.service
sudo systemctl enable neutron-linuxbridge-agent.service
sudo systemctl start neutron-linuxbridge-agent.service
## Add the startup scripts
### vi /root/startup.sh
```
#!/bin/bash

iptables -D INPUT -j REJECT --reject-with icmp-host-prohibited
iptables -D FORWARD -j REJECT --reject-with icmp-host-prohibited
iptables -A POSTROUTING -t mangle -p udp --dport 68 -j CHECKSUM --checksum-fill
service iptables save
```

### vi /etc/systemd/system/run-startup.service
```
[Unit]
After=network.service

[Service]
ExecStart=/root/startup.sh

[Install]
WantedBy=default.target
```
### enable the service
```
chmod +x /root/startup.sh
chmod 755 /root/startup.sh
chmod 664 /etc/systemd/system/run-startup.service

systemctl daemon-reload
systemctl enable run-startup.service
```
### RUN ON CONTROLLER NODE TO DISCOVER NEW HOSTS:
openstack compute service list --service nova-compute
su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova
openstack compute service list --service nova-compute
