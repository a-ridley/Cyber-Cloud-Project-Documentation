---
id: ip-netns-networking-techniques
title: Networking Techniques for ip netns
---


## Details
When debugging sometimes we aren't able to access our VM's thru our controller. This is usually because we create self-service networks hiding behind a virtual router.
You can execute commands thru the virtual router using ip netns.

### Verifying access through the router:
1. find the router id using:
`openstack router list`
2. find the virtual router using:
`ip netns list`
3. execute network calls from the router:
`ip netns exec <qrouter-id> ping <ip_address_on_router>`
4. view all routes connected to the virtual router.
`ip netns exec <qrouter-id> route -n`

