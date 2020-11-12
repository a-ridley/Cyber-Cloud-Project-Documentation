
# Creating an Availability Zone

## OpenStack CLI:
1. Login to the controller node, and load environment variables for the admin account using `. $(HOME)/admin.sh`.

Find Hosts:
```bash
openstack compute service list
```

Playbook:
```bash
openstack aggregate create <aggregate_name>
openstack aggregate set --zone <availability_zone_name> <aggregate_name>
openstack aggregate add host <aggregate_name> <host_name>
```

Example:
```bash
openstack aggregate create windows
openstack aggregate set --zone win windows
openstack aggregate add host windows compute3.usdcyber.edu
openstack aggregate add host windows compute5
```