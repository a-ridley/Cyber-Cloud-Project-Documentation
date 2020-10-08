---
id: bug-crazy-hypervisor
title: Hypervisor Issues
---


# Symptoms
- unable to create multiple large images.
- invalid information related to hypervisor details on openstack
# Diagnosis
- hypervisor summary confused, Unable to create multiple instances of large images
- finding the bug using:
```
tail -n 500 /var/log/nova/nova-scheduler.log | grep nova.filter
```
- results will shows that we are filtering out invalid compute nodes. looking into our compute nodes statistics we find that they only have about 60gb's of free space combined. which allows for 2-3 vms. (openstack hypervisor --help)
```
openstack hypervisor list
openstack hypervisor show <id>
```
# Solution
- This is because our hypervisor is using the wrong directory for its state.
- create a new folder in /home called nova, the path should be /home/nova then copy all the contents over from /etc/lib/nova/ into home/nova. `cp -r /var/lib/nova/ /home/`
- update `/etc/nova/nova.conf` in the compute node and set it's state_path variable to point to `/home/nova`
- any keys that reference $state_path should be uncommented.
- the following settings should be added (and should already be a part of our playbook for compute nodes)
```
[DEFAULT]
state_path=/home/nova
instances_path=$state_path/instances
networks_path=$state_path/networks

[libvrt]
nfs_mount_point_base=$state_path/mnt
quobyte_mount_point_base=$state_path/mnt
smbfs_mount_point_base=$state_path/mnt
vzstorage_mount_point_base=$state_path/mnt

[zvm]
image_tmp_path=$state_path/images
```

- reboot the nova services on the controller node.
- reboot the nova services on compute node
- grant nova user permission to the folder:
```
chown -R nova /home/nova 
chgrp -R nova /home/nova
```
- set SEL Linux permissions: 
```
//sesearch -s nova_var_lib_t --allow -d
stat /var/lib/nova
stat /home/nova

semanage fcontext -a -t nova_var_lib_t '/home/nova(/.*)?'

restorecon -vvRF /home/nova/
```
# Verification
- view and check to see if the resources allocated to the hypervisor increased.
```
openstack hypervisor show <id>
openstack hypervister stats show
```