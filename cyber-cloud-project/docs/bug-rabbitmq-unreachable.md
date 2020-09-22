# Symptoms
1. services are failing to perform standard procedures, things as simple as creating a new vm fails.

# Diagnosis:
1. error mesage is present in logs: ERROR oslo.messaging._drivers.impl_rabbit [-] [4eb644bc-b7c9-415c-8178-f13bc145abeb] AMQP server on controller:5672 is unreachable: timed out. Trying again in 2 seconds.
## With rabbit MQ:
1. you can attempt to log into the server remotely
```
rabbitmqadmin -H SERVER-IP -u USER_NAME -p PASSWORD list vhosts
transport_url = rabbit://openstack:<RABBITMQ_PASSWORD>@controller
rabbitmqctl -n openstack@controller list_users
```
## With Telnet* 
1. This approach is not recommended, only use if the situation is so dire you somehow cannot use the rabbitmqadmin command line tool to verify connectivity.
```
yum install telnet telnet-server -y
telnet controller 5672
```

# Solution:
1. TODO: It needs a better solution, this was resolved with a hard reboot, such an action is not recommended since the controller cannot be rebooted as it is our only production instance.
