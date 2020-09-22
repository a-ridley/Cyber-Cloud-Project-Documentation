# Report:
- Errors are reported all over the horizon dashboard or in the logs in other files.
- TODO: add screenshots/bug report images.
- appears as `(1040, u'Too many connections')` in log files.
- Rule #1: you should not have to reset the db.

# Diagnosing:
## connect to mysql
```
mysql -u root -p
```
## View variables
```
SHOW VARIABLES LIKE "max_connections";
```
> the bug is usually caused by max_connections being set too low.
```
SHOW VARIABLES LIKE "connect_timeout";
```
```
SHOW VARIABLES LIKE "wait_timeout";
```
```
SHOW VARIABLES LIKE "interactive_timeout";
```
## view active connections
```
SHOW status WHERE variable_name = 'threads_connected'; 
```
> the number will be equal to max_connections if we've hit the bug.
# Solution:
## Increase mariadb connection limit
```
SET GLOBAL max_connections = 4096;
```
# Verification:
- verify operation by using an openstack command: `openstack network list`

#### Notes: 

openstack security group rule create --ethertype IPv6 --proto ipv6-icmp 706bee23-9675-4657-8c87-ab84d9772312
openstack security group rule create --proto tcp --dst-port 22 706bee23-9675-4657-8c87-ab84d9772312
openstack security group rule create --ethertype IPv6 --proto tcp --dst-port 22 706bee23-9675-4657-8c87-ab84d9772312
openstack server create --flavor 1 --image cirros --nic net-id=83058d78-09cb-499f-91ed-74ea86135418 selfservice-instance1
