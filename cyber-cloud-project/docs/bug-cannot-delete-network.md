# Symptoms
- unable to delete a network because something is still attached.
# Diagnosis:
- TODO: more detailed steps are required to identify what is attached that is preventing deletion.
# Solution:
## Removing a subnet (non-sql, clears everything)
```
neutron router-gateway-clear router (check name with neutron router-list)
neutron router-interface-delete router selfservice
openstack router delete router
openstack subnet delete selfservice
openstack subnet delete provider
openstack network delete selfservice
openstack network delete provider
```
## Removing a subnet (Because there are one or orphaned ports still in use on the network): 
### find the ports
```
openstack port list --router <router>
```
### delete the ports:
```
mysql -u root -p
use neutron;
delete from ports where id='<id>';
```
### delete the subnet
```
delete from subnets where id='<id>';
```
### delete the router
```
delete from routers where id='<id>';
```
### delete the network
```
openstack network delete <network_name>;
```