#### Removing a subnet (non-sql)
neutron router-gateway-clear router (check name with neutron router-list)
neutron router-interface-delete router selfservice
openstack router delete router
openstack subnet delete selfservice
openstack subnet delete provider
openstack network delete selfservice
openstack network delete provider
#### Removing a subnet (There are one or more ports still in use on the network): 
##### find the ports
openstack port list --router [router]
##### delete the ports:
mysql -u root -p
e2833c5aff4940dcfa496ce0e0ccad
use neutron;
delete from ports where id='[id]';
##### delete the subnet
delete from subnets where id='[id]';
##### delete the router
delete from routers where id='[id]';
##### delete the network
openstack network delete [network_name];
