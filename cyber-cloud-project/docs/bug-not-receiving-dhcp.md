---
id: bug-not-receiving-dhcp
title: Instance Cannot Access Console on Horizon
---


# Symptoms:
- my instance is not receiving an IP from DHCP.
- my instance cannot access the console on OpenStack horizon dashboard.

- related links to find solution:
- https://ask.openstack.org/en/question/69126/instances-in-one-of-the-compute-nodes-cant-get-fixed-ip-address/
- https://www.youtube.com/watch?v=frUF6IuW_QM
- https://docs.openstack.org/operations-guide/ops-network-troubleshooting.html

# Diagnosing:
## Diagnosing with openstack CLI
1. Everything will look normal, the server builds, an IP is attached, but we cannot ping the server, not even from it's virtual router. 
2. If this is because DHCP is failing to allocate an IP. The server instance will report it in the logs.
3. Example error from `openstack console log show <server_name>:
```
cirros-ds 'local' up at 0.71
found datasource (configdrive, local)
Starting network...
udhcpc (v1.20.1) started
Sending discover...
Sending discover...
Sending discover...
Usage: /sbin/cirros-dhcpc <up|down>
No lease, failing
WARN: /etc/rc3.d/S40-network failed
```
## Diagnosing with syslogs
3. This bug can also be confirmed in the host controller's syslogs at `/var/log/messages/`. Where you'll see DHCP errors specifying something like: `controller dnsmasq-dhcp[4456]: DHCPDISCOVER(ns-4dcae4ef-73) 20:4c:03:37:a5:cd no address available`
## Diagnosing with tcpdump
1. the node instance run: `tcpdump -n -e -i <provider_interface> | grep admin`
2. wait a while and we may see the error message: `ICMP host <CONTROLLER_PROVIDER_IP> unreachable - admin prohibited`
# Solution:
1. on both the compute and controller node use : `iptables-save | grep icmp` to find whether or not there are any rules blocking icmp with the host.
2. if the following rules exist:
```
INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -o virbr0 -j REJECT --reject-with icmp-port-unreachable
-A FORWARD -i virbr0 -j REJECT --reject-with icmp-port-unreachable

```
3. we have to remove them:
```
iptables -D INPUT -j REJECT --reject-with icmp-host-prohibited
iptables -D FORWARD -j REJECT --reject-with icmp-host-prohibited
iptables -D FORWARD -o virbr0 -j REJECT --reject-with icmp-port-unreachable
iptables -D FORWARD -i virbr0 -j REJECT --reject-with icmp-port-unreachable
iptables -A POSTROUTING -t mangle -p udp --dport 68 -j CHECKSUM --checksum-fill
service iptables save
```
4. These rules should already exist as part of each compute nodes ./startup.sh rules if they don't add them!.
# Verifying
## Verifying through the router:
1. find the router id using: `openstack router list`
2. find the virtual router using: `ip netns list`
3. execute network calls from the router: `ip netns exec <qrouter-id> ping <ip_address_on_router>`
