# /root/startup.sh
This file is run on startup, there is a custom systemd function that is scheduled to run on boot. Add any scripts or rules here.

# vi /etc/systemd/system/run-startup.service

```
[Unit]
After=network.service

[Service]
ExecStart=/root/startup.sh

[Install]
WantedBy=default.target
```
# post installation.
place the two file in the correct locations.
```
chmod +x /root/startup.sh
chmod 755 /root/startup.sh
chmod 664 /etc/systemd/system/run-startup.service

systemctl daemon-reload
systemctl enable run-startup.service
```