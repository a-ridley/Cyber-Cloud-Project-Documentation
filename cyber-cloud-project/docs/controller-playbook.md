---
id: controller-node-playbook
title: Playbook for Controller Nodes
---

###### Note: This is a raw script please look at Ansible Guide Controller instead
## Controller
https://docs.openstack.org/install-guide/openstack-services.html#minimal-deployment-for-train

Unfortnately, it's a manual process at the moment...

Executing this playbook by hand is pretty simple. Follow the steps and notes as outlined,

Before starting this playbook, copy it to another file and change the variables inside of angled brackets <variable_name_reference> with the correct variable.

While executing the playbook, don't forget to backup all the original files and copy over all the contents from the playbook onto a new file.
# Playbook
## Firewall
sudo firewall-cmd --permanent --add-service=mysql
sudo firewall-cmd --zone=public --permanent --add-port=4369/tcp --add-port=25672/tcp --add-port=5671-5672/tcp --add-port=15672/tcp  --add-port=61613-61614/tcp --add-port=1883/tcp --add-port=8883/tcp
sudo firewall-cmd --new-zone=memcached --permanent
sudo firewall-cmd --zone=memcached --add-port=11211/udp --permanent
sudo firewall-cmd --zone=memcached --add-port=11211/tcp --permanent
sudo firewall-cmd --zone=memcached --add-source=10.0.0.0/24 --permanent
sudo firewall-cmd --zone=memcached --add-source=10.10.10.0/24 --permanent
sudo firewall-cmd --add-port={2379,2380}/tcp --permanent
sudo firewall-cmd --zone=public --add-port=5000/tcp --permanent
sudo firewall-cmd --permanent --zone=public --add-service=http
sudo firewall-cmd --permanent --zone=public --add-service=https
sudo firewall-cmd --add-port=9292/tcp --permanent
sudo firewall-cmd --add-port=9292/udp --permanent
sudo firewall-cmd --add-port=8778/tcp --permanent
sudo firewall-cmd --add-port={9696/tcp,9696/udp} --permanent
sudo firewall-cmd --add-port={5902/tcp,5902/udp} --permanent

sudo firewall-cmd --add-port={6080/tcp,6081/tcp,6082/tcp,8774/tcp,8775/tcp,8778/tcp} --permanent 
sudo firewall-cmd --add-port={9696/tcp,9696/udp} --permanent 
sudo firewall-cmd --add-port={68/tcp,68/udp} --permanent 
sudo firewall-cmd --add-port=5900-5999/tcp --permanent

sudo firewall-cmd --add-port=8776/tcp --permanent
sudo firewall-cmd --reload
## SELinux
setsebool -P nis_enabled 1
setsebool -P glance_api_can_network on 
semanage port -a -t http_port_t -p tcp 8778
semanage port -a -t http_port_t -p tcp 8774
## sudo vi /etc/chrony.conf (modify this file manually, do not blow away the entire file)
server 0.us.pool.ntp.org iburst
server 1.us.pool.ntp.org iburst
server 2.us.pool.ntp.org iburst
server 3.us.pool.ntp.org iburst

allow 10.10.10.0/24
## /etc/hosts
10.10.10.11  compute1  compute1.usdcyber.edu  
10.10.10.12  logging  logging.usdcyber.edu  
10.10.10.13  object1  object1.usdcyber.edu  
10.10.10.14  block1  block1.usdcyber.edu  
10.10.10.16  compute2  compute2.usdcyber.edu  
10.10.10.17  compute3  compute3.usdcyber.edu  
<CONTROLLER_MANAGEMENT_IP>  controller  controller.usdcyber.edu  
10.10.10.19  compute5  compute5.usdcyber.edu 
10.10.10.26  compute4  compute4.usdcyber.edu 
## /etc/my.cnf.d/openstack.conf
[mysqld]
bind-address = <CONTROLLER_MANAGEMENT_IP>
default-storage-engine = innodb
innodb_file_per_table = on
max_connections = 4096
collation-server = utf8_general_ci
character-set-server = utf8
## rabbitmqctl
sudo rabbitmqctl add_user openstack 
## sudo vi /etc/etcd/etcd.conf
#[Member]
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
ETCD_LISTEN_PEER_URLS="http://<CONTROLLER_MANAGEMENT_IP>:2380"
ETCD_LISTEN_CLIENT_URLS="http://<CONTROLLER_MANAGEMENT_IP>:2379"
ETCD_NAME="controller"
#[Clustering]
ETCD_INITIAL_ADVERTISE_PEER_URLS="http://<CONTROLLER_MANAGEMENT_IP>:2380"
ETCD_ADVERTISE_CLIENT_URLS="http://<CONTROLLER_MANAGEMENT_IP>:2379"
ETCD_INITIAL_CLUSTER="controller=http://<CONTROLLER_MANAGEMENT_IP>:2380"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster-01"
ETCD_INITIAL_CLUSTER_STATE="new"
## Keystone
### mysql
mysql -u root -p
<MYSQL_PASSWORD>

CREATE DATABASE keystone;
CREATE USER `keystone`@`localhost` IDENTIFIED BY '<KEYSTONE_DB_PASSWORD>';
GRANT ALL ON keystone.* TO `keystone`@`localhost`;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY '<KEYSTONE_DB_PASSWORD>';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY '<KEYSTONE_DB_PASSWORD>';

SELECT host, user, password FROM mysql.user;
SELECT DISTINCT CONCAT('SHOW GRANTS FOR ', QUOTE(user), '@', QUOTE(host), ';') AS query FROM mysql.user;
SET PASSWORD FOR 'keystone'@'localhost' = PASSWORD('<KEYSTONE_DB_PASSWORD>');
### openstack
#### /etc/keystone/keystone.conf 
[database]
connection = mysql+pymysql://keystone:<KEYSTONE_DB_PASSWORD>@controller/keystone
[token]
provider = fernet
### keystone-manage
keystone-manage bootstrap --bootstrap-password <ADMIN_PASSWORD> \
  --bootstrap-admin-url http://controller:5000/v3/ \
  --bootstrap-internal-url http://controller:5000/v3/ \
  --bootstrap-public-url http://controller:5000/v3/ \
  --bootstrap-region-id RegionOne
## Glance
### mysql
mysql -u root -p
<MYSQL_PASSWORD>
CREATE DATABASE glance;
CREATE USER `glance`@`localhost` IDENTIFIED BY '<GLANCE_DB_PASSWORD>';
GRANT ALL ON glance.* TO `glance`@`localhost`;
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY '<GLANCE_DB_PASSWORD>';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY '<GLANCE_DB_PASSWORD>';
### openstack
#### setup
openstack user create --domain default --password-prompt glance
<GLANCE_USER_PASSWORD>
openstack role add --project service --user glance admin
openstack service create --name glance --description "OpenStack Image" image
openstack endpoint create --region RegionOne image public http://controller:9292
openstack endpoint create --region RegionOne image internal http://controller:9292
openstack endpoint create --region RegionOne image admin http://controller:9292

sudo yum install openstack-glance -y
#### sudo vi /etc/glance/glance-api.conf
[database]
connection = mysql+pymysql://glance:<GLANCE_DB_PASSWORD>@controller/glance

[keystone_authtoken]
www_authenticate_uri  = http://controller:5000
auth_url = http://controller:5000
memcached_servers = controller:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = glance
password = <GLANCE_USER_PASSWORD>

[paste_deploy]
flavor = keystone

[glance_store]
stores = file,http
default_store = file
filesystem_store_datadir = /var/lib/glance/images/
#### enable glance
su -s /bin/sh -c "glance-manage db_sync" glance
sudo systemctl enable openstack-glance-api.service
sudo systemctl start openstack-glance-api.service
setsebool -P glance_api_can_network on 
#### verify
sudo yum install wget -y
wget http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img
glance image-create --name "cirros" --file cirros-0.4.0-x86_64-disk.img --disk-format qcow2 --container-format bare --visibility public
glance image-list
#### add images
openstack image create Centos7-BM --file IMAGE.iso --disk-format iso --container-format bare
glance image-create --name "Kali-C" --file --disk-format qcow2 --container-format bare --visibility public
## Placement
### sql
mysql -u root -p
<MYSQL_PASSWORD>
CREATE DATABASE placement;
CREATE USER `placement`@`localhost` IDENTIFIED BY '<PLACEMENT_DB_PASSWORD>';
GRANT ALL ON placement.* TO `placement`@`localhost`;
GRANT ALL PRIVILEGES ON placement.* TO 'placement'@'%' IDENTIFIED BY '<PLACEMENT_DB_PASSWORD>';
GRANT ALL PRIVILEGES ON placement.* TO 'placement'@'localhost' IDENTIFIED BY '<PLACEMENT_DB_PASSWORD>';
exit
### create user
openstack user create --domain default --password-prompt placement
<PLACEMENT_USER_PASSWORD>
openstack role add --project service --user placement admin
openstack service create --name placement --description "Placement API" placement
openstack endpoint create --region RegionOne placement public http://controller:8778
openstack endpoint create --region RegionOne placement internal http://controller:8778
openstack endpoint create --region RegionOne placement admin http://controller:8778
### openstack
#### pre
sudo yum install openstack-placement-api -y
#### /etc/placement/placement.conf
[placement_database]
connection = mysql+pymysql://placement:<PLACEMENT_DB_PASSWORD>@controller/placement
[api]
auth_strategy = keystone
[keystone_authtoken]
auth_url = http://controller:5000/v3
memcached_servers = controller:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = placement
password = <PLACEMENT_USER_PASSWORD>
#### post
su -s /bin/sh -c "placement-manage db sync" placement
sudo systemctl restart httpd
## Nova
### sql setup
mysql -u root -p
<MYSQL_PASSWORD>
CREATE DATABASE nova_api;
CREATE DATABASE nova;
CREATE DATABASE nova_cell0;
CREATE USER `nova`@`localhost` IDENTIFIED BY '<NOVA_DB_PASSWORD>';
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' IDENTIFIED BY '<NOVA_DB_PASSWORD>';
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' IDENTIFIED BY '<NOVA_DB_PASSWORD>';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY '<NOVA_DB_PASSWORD>';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY '<NOVA_DB_PASSWORD>';
GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' IDENTIFIED BY '<NOVA_DB_PASSWORD>';
GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%' IDENTIFIED BY '<NOVA_DB_PASSWORD>';
exit
### create user
openstack user create --domain default --password-prompt nova
<NOVA_USER_PASSWORD>
openstack role add --project service --user nova admin
openstack service create --name nova --description "OpenStack Compute" compute

openstack endpoint create --region RegionOne compute public http://controller:8774/v2.1

openstack endpoint create --region RegionOne compute internal http://controller:8774/v2.1

openstack endpoint create --region RegionOne compute admin http://controller:8774/v2.1
### openstack
#### pre
yum install openstack-nova-api openstack-nova-conductor openstack-nova-novncproxy openstack-nova-scheduler -y
#### /etc/nova/nova.conf
[DEFAULT]
enabled_apis = osapi_compute,metadata
my_ip = <CONTROLLER_MANAGEMENT_IP>
use_neutron = true
firewall_driver = nova.virt.firewall.NoopFirewallDriver
block_device_allocate_retries = 600
block_device_allocate_retries_interval = 10
block_device_creation_timeout = 300


[api_database]
connection = mysql+pymysql://nova:<NOVA_DB_PASSWORD>@controller/nova_api

[database]
connection = mysql+pymysql://nova:<NOVA_DB_PASSWORD>@controller/nova

[api]
auth_strategy = keystone

[keystone_authtoken]
www_authenticate_uri = http://controller:5000/
auth_url = http://controller:5000/
memcached_servers = controller:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = nova
password = <NOVA_USER_PASSWORD>

[vnc]
enabled = true
server_listen = $my_ip
server_proxyclient_address = $my_ip
novncproxy_base_url=http://<CONTROLLER_PROVIDER_IP>:6080/vnc_auto.html
novncproxy_port=6080
novncproxy_host=0.0.0.0

[glance]
api_servers = http://controller:9292

[oslo_concurrency]
lock_path = /var/lib/nova/tmp

[placement]
region_name = RegionOne
project_domain_name = Default
project_name = service
auth_type = password
user_domain_name = Default
auth_url = http://controller:5000/v3
username = placement
password = <PLACEMENT_USER_PASSWORD>
#### post
. admin.sh
su -s /bin/sh -c "nova-manage api_db sync" nova
su -s /bin/sh -c "nova-manage cell_v2 map_cell0" nova
su -s /bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova
su -s /bin/sh -c "nova-manage db sync" nova
su -s /bin/sh -c "nova-manage cell_v2 list_cells" nova
sudo systemctl enable openstack-nova-api.service
sudo systemctl enable openstack-nova-scheduler.service
sudo systemctl enable openstack-nova-conductor.service
sudo systemctl enable openstack-nova-novncproxy.service
sudo systemctl start openstack-nova-api.service
sudo systemctl start openstack-nova-scheduler.service
sudo systemctl start openstack-nova-conductor.service
sudo systemctl start openstack-nova-novncproxy.service
su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova
openstack compute service list --service nova-compute
### verify
openstack compute service list
openstack catalog list
openstack image list
nova-status upgrade check
## Neutron
### sql setup
mysql -u root -p
<MYSQL_PASSWORD>
CREATE DATABASE neutron;
CREATE USER `neutron`@`localhost` IDENTIFIED BY '<NEUTRON_DB_PASSWORD>';
GRANT ALL ON neutron.* TO `neutron`@`localhost`;
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY '<NEUTRON_DB_PASSWORD>';
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY '<NEUTRON_DB_PASSWORD>';
### create user
. admin.sh
openstack user create --domain default --password-prompt neutron
<KEYSTONE_UER_PASSWORD>
openstack role add --project service --user neutron admin
openstack service create --name neutron --description "OpenStack Networking" network
openstack endpoint create --region RegionOne network public http://controller:9696
openstack endpoint create --region RegionOne network internal http://controller:9696
openstack endpoint create --region RegionOne network admin http://controller:9696
### openstack:
#### pre
sudo yum install openstack-neutron -y
sudo yum install openstack-neutron-ml2 -y
sudo yum install openstack-neutron-linuxbridge -y
sudo yum install ebtables -y
#### sudo vi /etc/neutron/neutron.conf
[DEFAULT]
core_plugin = ml2
service_plugins = router
allow_overlapping_ips = true
transport_url = rabbit://openstack:<RABBITMQ_PASSWORD>@controller
notify_nova_on_port_status_changes = true
notify_nova_on_port_data_changes = true

[database]
connection = mysql+pymysql://neutron:<NEUTRON_DB_PASSWORD>@controller/neutron

[keystone_authtoken]
www_authenticate_uri = http://controller:5000
auth_url = http://controller:5000
memcached_servers = controller:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = neutron
password = <KEYSTONE_UER_PASSWORD>

[nova]
auth_url = http://controller:5000
auth_type = password
project_domain_name = default
user_domain_name = default
region_name = RegionOne
project_name = service
username = nova
password = <NOVA_USER_PASSWORD>

[oslo_concurrency]
lock_path = /var/lib/neutron/tmp
#### sudo vi /etc/neutron/plugins/ml2/ml2_conf.ini
[ml2]
type_drivers = flat,vlan,vxlan
tenant_network_types = vxlan
mechanism_drivers = linuxbridge,l2population
extension_drivers = port_security

[ml2_type_flat]
flat_networks = provider

[ml2_type_vxlan]
vni_ranges = 1:1000

[securitygroup]
enable_ipset = true
#### sudo vi /etc/neutron/plugins/ml2/linuxbridge_agent.ini
[linux_bridge]
physical_interface_mappings = provider:<CONTROLLER_PROVIDER_NETWORK_INTERFACE>

[vxlan]
enable_vxlan = true
local_ip = <CONTROLLER_PROVIDER_IP>
l2_population = true

[securitygroup]
enable_security_group = true
firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver
##### post
modprobe br_netfilter
sysctl -p
sysctl net.bridge.bridge-nf-call-iptables
sysctl net.bridge.bridge-nf-call-ip6tables
#### sudo vi /etc/neutron/l3_agent.ini
[DEFAULT]
interface_driver = linuxbridge
#### sudo vi /etc/neutron/dhcp_agent.ini
[DEFAULT]
interface_driver = linuxbridge
dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
enable_isolated_metadata = true
#### sudo vi /etc/neutron/metadata_agent.ini 
[DEFAULT]
nova_metadata_host = controller
metadata_proxy_shared_secret=<METADATA_SHARED_SECRET>
#### sudo vi /etc/nova/nova.conf
[neutron]
auth_url = http://controller:5000
auth_type = password
project_domain_name = default
user_domain_name = default
region_name = RegionOne
project_name = service
username = neutron
password = <KEYSTONE_UER_PASSWORD>
service_metadata_proxy = true
metadata_proxy_shared_secret=   
#### post
ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini
su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron
systemctl restart openstack-nova-api.service
sudo systemctl enable neutron-server.service
sudo systemctl enable neutron-linuxbridge-agent.service
sudo systemctl enable neutron-dhcp-agent.service
sudo systemctl enable neutron-metadata-agent.service
sudo systemctl enable neutron-l3-agent.service
sudo systemctl start neutron-server.service
sudo systemctl start neutron-linuxbridge-agent.service 
sudo systemctl start neutron-dhcp-agent.service
sudo systemctl start neutron-metadata-agent.service
sudo systemctl start neutron-l3-agent.service

##### Compute Node
modprobe br_netfilter
sysctl -p
sysctl net.bridge.bridge-nf-call-iptables
sysctl net.bridge.bridge-nf-call-ip6tables
sudo systemctl restart openstack-neutron-linuxbridge.service
sudo systemctl restart neutron-linuxbridge-agent.service
sudo systemctl restart openstack-nova-compute.service
### verify
. admin.sh
openstack network agent list
## Horizon
sudo yum install openstack-dashboard -y
### sudo vi /etc/openstack-dashboard/local_settings
SITE_BRANDING = 'USD Cyber Security'
ALLOWED_HOSTS = ['*']
OPENSTACK_HOST = "controller"
OPENSTACK_KEYSTONE_URL = "http://%s:5000/v3" % OPENSTACK_HOST
OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = True
OPENSTACK_API_VERSIONS = {
    "identity": 3,
    "image": 2,
    "volume": 3,
}
OPENSTACK_KEYSTONE_DEFAULT_DOMAIN = "Default"
OPENSTACK_KEYSTONE_DEFAULT_ROLE = "user"
WEBROOT = '/dashboard/'

#### memcached section
SESSION_ENGINE = 'django.contrib.sessions.backends.cache'

CACHES = {
    'default': {
         'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
         'LOCATION': 'controller:11211',
    }
}
### sudo vi /etc/httpd/conf.d/openstack-dashboard.conf
WSGIApplicationGroup %{GLOBAL}
### verify
sudo systemctl restart httpd
## Cinder
### Controller Node
#### Dependencies
sudo yum install openstack-cinder -y
#### MySQL
mysql -u root -p
<MYSQL_PASSWORD>
CREATE DATABASE cinder;
CREATE USER `cinder`@`localhost` IDENTIFIED BY '<CINDER_DB_PASSWORD>';
GRANT ALL ON cinder.* TO `cinder`@`localhost`;
GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' IDENTIFIED BY '<CINDER_DB_PASSWORD>';
GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' IDENTIFIED BY '<CINDER_DB_PASSWORD>';
exit
#### Openstack
. admin.sh
openstack user create --domain default --password-prompt cinder
<CINDER_USER_PASSWORD>
openstack role add --project service --user cinder admin
openstack service create --name cinderv2 --description "OpenStack Block Storage" volumev2
openstack service create --name cinderv3 --description "OpenStack Block Storage" volumev3
openstack endpoint create --region RegionOne volumev2 public http://controller:8776/v2/%\(project_id\)s
openstack endpoint create --region RegionOne volumev2 internal http://controller:8776/v2/%\(project_id\)s
openstack endpoint create --region RegionOne volumev2 admin http://controller:8776/v2/%\(project_id\)s
openstack endpoint create --region RegionOne volumev3 public http://controller:8776/v3/%\(project_id\)s
openstack endpoint create --region RegionOne volumev3 internal http://controller:8776/v3/%\(project_id\)s
openstack endpoint create --region RegionOne volumev3 admin http://controller:8776/v3/%\(project_id\)s
#### Configure
##### sudo vi /etc/cinder/cinder.conf

[DEFAULT]
transport_url = rabbit://openstack:<RABBITMQ_PASSWORD>@controller
auth_strategy = keystone
my_ip = <CONTROLLER_MANAGEMENT_IP>

[database]
connection = mysql+pymysql://cinder:<CINDER_DB_PASSWORD>@controller/cinder

[keystone_authtoken]
www_authenticate_uri = http://controller:5000
auth_url = http://controller:5000
memcached_servers = controller:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = cinder
password = <CINDER_USER_PASSWORD>

[oslo_concurrency]
lock_path = /var/lib/cinder/tmp
#### sudo vi /etc/nova/nova.conf
[cinder]
os_region_name = RegionOne
 
### Finalize
su -s /bin/sh -c "cinder-manage db sync" cinder
sudo systemctl restart openstack-nova-api.service
sudo systemctl enable openstack-cinder-api.service openstack-cinder-scheduler.service
sudo systemctl start openstack-cinder-api.service openstack-cinder-scheduler.service

### Verify
. admin.sh
openstack volume service list