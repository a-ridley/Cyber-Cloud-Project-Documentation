---
id: active-maintenance-script
title: The Active Maintenance Script
---

Run it to prevent students from attempting to logging on.

/root/active-maintenance-toggle.sh ['on' | 'off']

Running the script will replace the file in `/usr/share/openstack-dashboard/openstack_dashboard/templates/base.html` with dev.base.html, or prod.base.html depending on your argument. 