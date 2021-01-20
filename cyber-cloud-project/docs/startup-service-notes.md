---
id: startup-service-notes
title: Run on Startup
---


## /root/startup.sh
This file is runs every 5 minutes on all nodes using a cronjob. 


:::tip

The cronjob lives on the logging node and there is an Ansible playbook that is in charge of running it on all nodes.

:::



 Create a custom systemd function that is scheduled to run on boot. Add any scripts or rules here.

## vi /etc/systemd/system/run-startup.service

```
[Unit]
After=network.service

[Service]
ExecStart=/root/startup.sh

[Install]
WantedBy=default.target
```
## post installation.
place the two file in the correct locations.
```
chmod +x /root/startup.sh
chmod 755 /root/startup.sh
chmod 664 /etc/systemd/system/run-startup.service

systemctl daemon-reload
systemctl enable run-startup.service
```