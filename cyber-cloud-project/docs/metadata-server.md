---
id: metadata-server
title: Developer Guide for Metadata Server
---

# Metadata Server

The metadata server is a small express js app that connects to openstack and grabs data. Clients can make requests to the express app to receive data, this app bypasses the standard security measures required to request an openstack token such as a username and password. Since we know where all requests are coming from we can add our own rule to prevent requests from non-vm's to the metadata server. As of september 2020 this feature is not implemented and anyone on the network can make a request. The only endpoint that exist is `/hostname`, it takes in parameters `?ip=<ipv4>` it responds with the correct hostname for that vm.

The metadata server files can be located on the logging server in /home/metadata-server, once enabled the server is actively listening on port 8069.

## Modifying the server:
make changes to the file "server.js", and then build the image with the command:
```
docker build -t metadata:latest -f Dockerfile . 
```
## Stop Server:
```
sudo docker stop metadata-server
```
## Start Server:
```
sudo docker run -it -p 8069:8069 --rm --name metadata-server metadata
```
## Endpoints:
The primary means of testing is with curl. Using the hostname <logging_server>:<logging_port>
### /hostname
the /hostname endpoint allows queries for a machine's hostname.
#### ?ip=<ipv4>
use the ip parameter to filter down to a specific machine.
```
curl <logging_server>:8069/hostname?ip=10.10.1.235
```
# The Client
In order to configure an image to support automated hostname detection, we have created a custom OWASP BWA image called "OWASP BWA Automated", this is a snapshot, but vm instances can be created from it.

Setting up the client requires modifications in 2 places
## /script/startup.sh
this script is automatically deleted after the first boot.
```
#!/bin/bash
my_ip$(hostname -I | awk '{print $1}')
curl 192.168.128.12:8069/hostname?ip=$my_ip -o /etc/hostname
```
##  /etc/rc.local
The rc.local file must have the following appended to it:
```
FILE=/scripts/startup.sh
if test -f "$FILE"; then
    echo "$FILE exists."
    /scripts/startup.sh
    rm -f $FILE
    reboot
fi
```
## Configuring the image
Once the VM is prepared, follow the steps in "deploying a vm from a snapshot"