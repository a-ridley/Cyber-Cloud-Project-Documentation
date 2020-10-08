# Diagnosing
## Instances
1. openstack server show <instance_name>
2. openstack server list
3. openstack server delete <instance_name>
## Keystone
### Logs
```
sudo tail /var/log/httpd/keystone.log -n 100 | grep -E -C 5 '(ERROR|error)'
```
### Services
```
systemctl <action> httpd.service
```
## Nova
### Controller
#### Services
```
systemctl <action> openstack-nova-api.service;
systemctl <action> openstack-nova-scheduler.service;
systemctl <action> openstack-nova-conductor.service;
systemctl <action> openstack-nova-novncproxy.service;
```
#### Logs
```
tail /var/log/nova/nova-api.log 
tail /var/log/nova/nova-conductor.log
tail /var/log/nova/nova-manage.log
tail /var/log/nova/nova-novncproxy.log
tail /var/log/nova/nova-scheduler.log
```
##### With Errors
```
tail /var/log/nova/nova-api.log -n 100 | grep -E -C 5 '(ERROR|error)'
tail /var/log/nova/nova-conductor.log -n 100 | grep -E -C 5 '(ERROR|error)'
tail /var/log/nova/nova-manage.log -n 100 | grep -E -C 5 '(ERROR|error)'
tail /var/log/nova/nova-novncproxy.log -n 100 | grep -E -C 5 '(ERROR|error)'
tail /var/log/nova/nova-scheduler.log -n 100 | grep -E -C 5 '(ERROR|error)'
```
#### Command Line Verification
1. `openstack compute service list`
2. `openstack compute service list --service nova-compute`
#### Discovering new compute hosts
0. This has been automated, but this command can be used to identify new hosts.
1. `su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova`
### Compute
#### Logs
#### Services
##### Status
sudo systemctl <action> libvirtd.service 
sudo systemctl <action> openstack-nova-compute.service
## Neutron
### ip netns
```
[root@controller ~]# ip netns exec qrouter-9e10a7ca-5ba8-4856-902a-6f5a0f685efa route -n^C
[root@controller ~]# ip netns exec qrouter-9e10a7ca-5ba8-4856-902a-6f5a0f685efa ping 10.10.11.1
ip netns list
```
1. find your router and dhcp by the port network identifiers (horizon => project => network => routers => interfaces => network_id)
### Controller

#### Verification
```
openstack network agent list
```