---
id: block-node-playbook
title: Playbook for Block Nodes
---

###### Note: This is a raw script please look at Ansible Guide Block instead

# Notes
https://docs.openstack.org/install-guide/openstack-services.html#minimal-deployment-for-train

Unfortnately, it's a manual process at the moment...
# Playbook
## Firewall
sudo firewall-cmd --add-port={3260/tcp,3260/udp} --permanent
sudo firewall-cmd --reload
## Environment
### sudo vi /etc/hosts/
10.10.10.11  compute1.usdcyber.edu    compute1
10.10.10.12  logging.usdcyber.edu     logging
10.10.10.13  object1.usdcyber.edu     object1
10.10.10.14  block1.usdcyber.edu      block1
10.10.10.16  compute2.usdcyber.edu    compute2
10.10.10.17  compute3.usdcyber.edu    compute3
10.10.10.18  controller.usdcyber.edu  controller
10.10.10.19  network1.usdcyber.edu    network1
### vi /etc/chrony.conf
server controller iburst
## Storage Node
### Dependencies
sudo yum install lvm2 device-mapper-persistent-data -y
sudo yum install openstack-cinder targetcli python-keystone -y
### Initialization
sudo systemctl enable lvm2-lvmetad.service
sudo systemctl start lvm2-lvmetad.service
sudo pvcreate /dev/sdb
sudo vgcreate cinder-volumes /dev/sdb

sudo pvcreate /dev/sdc
sudo vgcreate cinder-volumes /dev/sdc
### sudo vi /etc/lvm/lvm.conf 
filter = [ "a/sda/", "a/sdb/", "r/.*/"]
### Configure
#### sudo vi /etc/cinder/cinder.conf
[DEFAULT]
transport_url = rabbit://openstack:<RABBITMQ_PASSWORD>@controller
auth_strategy = keystone
my_ip = 10.10.10.14
enabled_backends = lvm
glance_api_servers = http://controller:9292

[database]
connection = mysql+pymysql://cinder:<CINDER_PASWORD>@controller/cinder

[keystone_authtoken]
www_authenticate_uri = http://controller:5000
auth_url = http://controller:5000
memcached_servers = controller:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = cinder
password = <CINDER_PASWORD>

[lvm]
volume_driver = cinder.volume.drivers.lvm.LVMVolumeDriver
volume_group = cinder-volumes
target_protocol = iscsi
target_helper = lioadm

[oslo_concurrency]
lock_path = /var/lib/cinder/tmp
## Finalize
sudo systemctl enable openstack-cinder-volume.service target.service
sudo systemctl start openstack-cinder-volume.service target.service