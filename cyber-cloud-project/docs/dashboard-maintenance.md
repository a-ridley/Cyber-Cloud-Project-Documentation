---
id: dashboard-maintenance
title: Dashboard Maintenance
---


## Paths to make modifications to html
1. static resources go in => `/usr/share/openstack-dashboard/openstack_dashboard/static/dashboard/img/`
2. changes to html go in => `/usr/share/openstack-dashboard/openstack_dashboard/templates/`

## updating policy files correctly

https://docs.openstack.org/oslo.policy/latest/cli/oslopolicy-policy-generator.html
```
[7:17 PM] Campos, Miguel A CTR (USA)
you posted a picture with the command i googled it and found this change log: https://docs.openstack.org/releasenotes/keystone/train.html
​
[7:17 PM] Campos, Miguel A CTR (USA)
which lead me to the outdated documentation here: https://docs.openstack.org/oslo.policy/latest/cli/oslopolicy-policy-generator.html

​[7:18 PM] Campos, Miguel A CTR (USA)
but i typed oslopolicy-policy-upgrade -h because the screenshot said to try it.

oslopolicy-policy-upgrade --config-file /etc/glance/glance-api.conf --format json --namespace glance --output-file glance_policy_2.json --policy glance_policy.yaml
```
## displaying panels to administrators only

1. locate the file (example):
```
[root@controller network_topology]# /usr/share/openstack-dashboard/openstack_dashboard/dashboards/project/network_topology/panel.py
```
2. add the line `policy_rules = (("network", "context_is_admin"),)` at the end like so:
```
class Routers(horizon.Panel):
    name = _("Routers")
    slug = 'routers'
    permissions = ('openstack.services.network',)
    policy_rules = (("network", "context_is_admin"),)
```
