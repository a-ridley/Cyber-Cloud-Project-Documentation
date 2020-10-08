#!/bin/bash
cd /usr/share/openstack-dashboard/openstack_dashboard/templates/
rm -f base.html
if [ "$1" == "on" ]; then
    echo "deploying development templates";
    cp dev.base.html base.html
else
    echo "deploying production template";
    cp prod.base.html base.html
fi
echo "restarting the httpd server";
systemctl restart httpd