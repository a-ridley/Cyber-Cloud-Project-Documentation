---
id: instance-maintenance
title: Maintenance for Instances
---
# Notes:
everytime you see `. admin.sh`|`. demo.sh` this means we are sourcing the admin/demo credentials, the openstack CLI tool uses environment variables to authenticate and process requests.
# Creating a provider network:
```
. admin.sh
```
```
openstack network create --share --external --provider-physical-network provider --provider-network-type flat provider
```
```
openstack subnet create --network provider --allocation-pool start=192.168.128.201,end=192.168.128.254 --dns-nameserver 8.8.8.8 --gateway 192.168.128.1 --subnet-range 192.168.128.0/24 provider
```
> The allocation pool of ip's must be free on the provider router, otherwise we risk collisions.
# Creating self service network:
```
. demo.sh
```
## create a network
```
openstack network create selfservice
```
```
openstack subnet create --network selfservice --dns-nameserver 8.8.8.8 --gateway 172.16.1.1 --subnet-range 172.16.1.0/24 selfservice
```
## create a router
```
openstack router create router
```
```
openstack router add subnet router selfservice
```
```
openstack router set router --external-gateway provider
```
## verify
```
. admin.sh
```
```
ip netns
```
```
openstack port list --router router
```
```
ping -c 4 <router_ip>
```
## keys:
```
. demo.sh
```
```
ssh-keygen -q -N ""
```
```
openstack keypair create --public-key ~/.ssh/id_rsa.pub mykey
```
```
openstack keypair list
```
## security group rules:
```
. demo.sh
```
```
openstack security group rule create --proto icmp default
```
```
openstack security group rule create --proto tcp --dst-port 22 default
```
# Deploying a provider instance:
## Gather information
```
. demo.sh
```
```
openstack flavor list
```
```
openstack image list
```
```
openstack network list
```
```
openstack security group list
```
## create:
```
openstack server create --flavor m1.nano --image cirros --nic net-id=4fc1008e-c33e-4b2e-a5ea-728ec18f506b --security-group default --key-name mykey provider-instance
```
## verify:
```
openstack server list
```
```
openstack console url show provider-instance
```
# Deploy a selfservice instance:
```
openstack server create --flavor m1.nano --image cirros --nic net-id=6884f821-c6c0-42db-ba13-242636910741 --security-group default --key-name mykey selfservice-instance
```
