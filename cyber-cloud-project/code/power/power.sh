#!/bin/bash
# This file serves to help encapsulate linux commands/processes into easier to memorize script names.
keystone_path="/etc/keystone/keystone.conf"
host_path="/etc/hosts"
chrony_path="/etc/chrony.conf"
os_conf_path="/etc/my.cnf.d/openstack.conf"
memcached_path="/etc/sysconfig/memcached"
etcd_path="/etc/etcd/etcd.conf"
neutron_path="/etc/neutron/neutron.conf"
network_ml2_path="/etc/neutron/plugins/ml2/ml2_conf.ini"
network_bridge_agent_path="/etc/neutron/plugins/ml2/linuxbridge_agent.ini"

function connect_to_database {
    mysql --user="root" --password="$MYSQL_ROOT_PASS";
}

function clear_env_packages {
  sudo yum remove etcd -y
  sudo yum remove memcached -y
  sudo yum remove python-memcached -y
  sudo yum remove rabbitmq-server -y
  sudo yum remove mariadb -y
  sudo yum remove mariadb-server -y
  sudo yum remove python2-PyMySQL -y
  sudo yum remove openstack-selinux -y
  sudo yum remove python-openstackclient -y
  sudo yum remove centos-release-openstack-train -y
  sudo yum remove chrony -y
}

#$1 = IS_COMPUTE_NODE
function restart_env_services {
    if [ -z "$1" ]; then
        sudo systemctl restart chronyd;
        sudo systemctl restart mariadb.service;
        sudo systemctl restart rabbitmq-server.service;
        sudo systemctl restart memcached.service;
        sudo systemctl restart etcd;
    else 
        sudo systemctl restart chronyd;
    fi
}

function restart_keystone_services {
    sudo systemctl restart httpd.service;
}

function restart_glance_services {
    sudo systemctl restart openstack-glance-api.service;
}

function restart_placement_services { 
    sudo systemctl restart httpd;
}

function compute_node_services {
    if [ -z "$1" ]; then
        sudo systemctl restart openstack-nova-compute.service;
        sudo systemctl restart neutron-linuxbridge-agent.service;
        sudo systemctl restart libvirtd.service;
        sudo systemctl restart openstack-nova-compute.service;
        sudo systemctl restart chronyd;
    else 
        sudo systemctl stop openstack-nova-compute.service;
        sudo systemctl stop neutron-linuxbridge-agent.service;
        sudo systemctl stop libvirtd.service;
        sudo systemctl stop openstack-nova-compute.service;
        sudo systemctl stop chronyd;
    fi
}

function compute_nova_services {
    sudo systemctl restart libvirtd.service;
    sudo systemctl restart openstack-nova-compute.service;
}

function controller_nova_services {
    sudo systemctl restart openstack-nova-api.service;
    sudo systemctl restart openstack-nova-scheduler.service;
    sudo systemctl restart openstack-nova-conductor.service;
    sudo systemctl restart openstack-nova-novncproxy.service;
}
    
function compute_neutron_services {
    sudo systemctl stop openstack-nova-compute.service;
    sudo systemctl stop neutron-linuxbridge-agent.service;
}

function controller_neutron_services {
    sudo systemctl restart openstack-nova-api.service;
    sudo systemctl restart neutron-server.service;
    sudo systemctl restart neutron-linuxbridge-agent.service;
    sudo systemctl restart neutron-dhcp-agent.service;
    sudo systemctl restart neutron-metadata-agent.service;
    sudo systemctl restart neutron-l3-agent.service;
}

function controller_cinder_services {
   systemctl restart openstack-nova-api.service
   systemctl restart openstack-cinder-api.service 
   systemctl restart openstack-cinder-scheduler.service
}

function block_cinder_services {
    systemctl restart lvm2-lvmetad.service
    systemctl restart openstack-cinder-backup.service
    systemctl restart openstack-cinder-volume.service 
    systemctl restart target.service
}

function disable_vibr0 {
    systemctl stop libvirtd.service;
    systemctl disable libvirtd.service;
    systemctl reboot;
}

#$1 = USERNAME
#$2 = PROJECTNAME
function request_token {
    unset OS_AUTH_URL OS_PASSWORD
    openstack --os-auth-url http://controller:5000/v3 --os-project-domain-name Default --os-user-domain-name Default --os-project-name $2 --os-username $1 token issue;
}

#$1=USERNAME
#$2=PASSWORD
#$3=DATABASE
function create_database_user {
    mysql --user="root" --password="$MYSQL_ROOT_PASS" --execute="\
        CREATE DATABASE $3;\
        CREATE USER '$1'@'localhost' IDENTIFIED BY '$2';\
        GRANT ALL ON $3.* TO $1@localhost;\
        GRANT ALL PRIVILEGES ON $3.* TO '$1'@'%' IDENTIFIED BY '$2';\
        GRANT ALL PRIVILEGES ON $3.* TO '$1'@'localhost' IDENTIFIED B$Y '$2';"
}

function shutdown_compute_service {
    sudo systemctl stop libvirtd.service openstack-nova-compute.service
}

function verify_clients { chronyc clients; }

function verify_sources { chronyc sources; }

# TODO: make downloaded files executable or automatically import them into our workspace, and save their version in a cache."
#$1 = URL
function download { wget $1; }

function update {
    echo "TODO: check script version and update them if necessary."
}

function list_users { getent passwd | awk -F: '{print $1}'; }

#$1 = USERNAME
function delete_user { userdel -r $1; }

#$1 = USERNAME
#$2 = PASSWORD
function create_admin {
    sudo useradd $1;
    echo "$1:$2" | chpasswd;
    echo "$1 ALL=(root) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/$1;
    sudo chmod 0440 /etc/sudoers.d/$1;
    whoami;
}

#cpwd: Create Password
#$1=PASSWORD_LENGTH >> DEFAULTS_TO(10)
function cpwd {
    if [ -z "$1" ]; then
        openssl rand -hex 15;
    else 
        openssl rand -hex $1;
    fi
}

function os_clear_env {
    unset OS_AUTH_URL OS_PASSWORD
}

function os_load_demo_user {
    export OS_PROJECT_DOMAIN_NAME=Default
    export OS_USER_DOMAIN_NAME=Default
    export OS_PROJECT_NAME=MiguelWorkspace
    export OS_USERNAME=myuser
    export OS_PASSWORD=<REPLACE_PASSWORD>
    export OS_AUTH_URL=http://controller:5000/v3
    export OS_IDENTITY_API_VERSION=3
    export OS_IMAGE_API_VERSION=2
}

function os_load_miguel {
    export OS_PROJECT_DOMAIN_NAME=Default
    export OS_USER_DOMAIN_NAME=Default
    export OS_PROJECT_NAME=MiguelWorkspace
    export OS_USERNAME=mcampos
    export OS_PASSWORD=<REPLACE_PASSWORD>
    export OS_AUTH_URL=http://controller:5000/v3
    export OS_IDENTITY_API_VERSION=3
    export OS_IMAGE_API_VERSION=2
}

function os_load_admin_user {
    export OS_USERNAME=admin
    export OS_PASSWORD=<REPLACE_PASSWORD>
    export OS_PROJECT_NAME=admin
    export OS_USER_DOMAIN_NAME=Default
    export OS_PROJECT_DOMAIN_NAME=Default
    export OS_AUTH_URL=http://controller:5000/v3/
    export OS_IDENTITY_API_VERSION=3
}

#$1=HOST_IP_ADDRES
#$1=HOST_NICKNAME
function update_hosts {
    if [ -z "$1" ]; then
        echo "Invalid host entry! [$1, $2]"
    else
        local new_host_entry="$1  $2.$NETWORK_HOST_NAME  $2"
        local line_number=$(find_line "$1" $host_path)
        if [ -z "$line_number" ]; then
            local result=`echo "$new_host_entry" | sudo tee -a $host_path;`
            echo "added new host entry for: $result"
        else
            echo "host entry already exits: $new_host_entry"
        fi
    fi
}

#Deletes all lines matching the specified text.
#$1=TARGET_TEXT
#$2=FILE_PATH
function delete_entry {
    sudo sed -i "/$1/d" "$2";
}

#Appends entry after the phrase specified, if no phrase is specified appends to end of file.
#$1=ENTRY
#$2=FILE_PATH
#$3=AFTER_PHRASE
function add_entry {
    local line_number=$(find_line "$1" "$2")
    if [ -z "$line_number" ]; then
        if [ -z $3 ]; then
            local r=`echo $1 | sudo tee $2 -a`;
            echo "appended text to the end of the file: $r";
        else
            sudo sed -i "/$3/ a $1" "$2";
            echo "added a new key to file $2 after phrase '$3': [$1]";
        fi
    else
        echo "duplicate entry: $1 already exists";
    fi
}

#$1=ENTRY_KEY
#$2=ENTRY_VALUE
#$3=FILE_PATH
#$4=AFTER_PHRASE
function update_entry {
    local line_number=$(find_line "$1" "$3")
    if [ -z "$line_number" ]; then
        add_entry "$2" "$3" "$4";
    else
        if [ -z "$4" ]; then
            #get the value at that line number and delete it.
            sudo sed -i "/$1/c $2" $3
            echo "updated entry at line number $line_number in file $3 to $2";
        else
            echo "TODO";
        fi
    fi
}

#$1=PHRASE
#$2=FILE
function find_line {
    local line_number=$(sudo grep -n "$1" "$2" | head -n 1 | cut -d: -f1)
    echo "$line_number"
}
