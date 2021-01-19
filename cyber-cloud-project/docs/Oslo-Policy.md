---
id: oslo-policy
title: Oslo-Policy (Permissions)
---

Each service in openstack has their own set of policies and they use the oslo policy engine to define policy rules. These poliices are taken straight from source code. Therefore, if there is any need to edit the default policies for each service they must be generated. 

In order to generate the default policy file for *each* service you must run the following commands on the Controller node. **(Note: This only has to be done once per service)**

        cd /etc/keystone
        oslopolicy-policy-generator --namespace keystone --output-file keystone_policy.json
        cd /etc/glance
        oslopolicy-policy-generator --namespace glance --output-file glance_policy.json
        cd /etc/nova
        oslopolicy-policy-generator --namespace nova --output-file nova_policy.json
        cd /etc/neutron
        oslopolicy-policy-generator --namespace neutron --output-file neutron_policy.json
        cd /etc/cinder
        oslopolicy-policy-generator --namespace cinder --output-file cinder_policy.json


Horizon implements policies by using copies of the policy files found in a service's source code. However, if you generate default policies using the above command you are going to need to copy each service's policy.json file to a location Horizon can find them. The conf dirctory may or may not exist.


Inside `defaults.py` you will notice there is a line that says: 
        # Path to directory containing policy.json files
        POLICY_FILES_PATH = os.path.join(_get_root_path(), "conf")
`conf` is the folder that Horizon is going to be looking for the policy files.


### Make the conf directory if it doesn't already exists
        mkdir /usr/share/openstack-dashboard/openstack_dashboard/conf

        # copy over all those policy files to the that conf directory
        cp /etc/keystone/keystone_policy.json /usr/share/openstack-dashboard/openstack_dashboard/conf/keystone_policy.json
        cp /etc/glance/glance_policy.json /usr/share/openstack-dashboard/openstack_dashboard/conf/glance_policy.json
        cp /etc/nova/nova_policy.json /usr/share/openstack-dashboard/openstack_dashboard/conf/nova_policy.json
        cp /etc/neutron/neutron_policy.json /usr/share/openstack-dashboard/openstack_dashboard/conf/neutron_policy.json


Make changes in `/usr/share/openstack-dashboard/openstack_dashboard/defaults.py`.

In order for Horizon to be able to interpret these policy files we must first ensure that `defaults.py` at `/usr/share/openstack-dashboard/openstack_dashboard` has the following:

        POLICY_FILES = {
            'identity': 'keystone_policy.json',
            'compute': 'nova_policy.json',
            'volume':'cinder_policy.json',
            'image': 'glance_policy.json',
            'network': 'neutron_policy.json'
        }

If the above is not present in defaults.py add it!

Sources: [Horizon Policy Enforcement (RBAC: Role Based Access Control)](https://docs.openstack.org/horizon/latest/contributor/topics/policy.html)


###NOTE: The generated keystone_policy.json will have a lot of rules that deal with scope. This is not the policy file we want unless your system can handle scope. If not, please look for the depcracted keystone_policy file with simpler rules. more info here: 

https://www.reddit.com/r/openstack/comments/ibtmwo/admin_user_cannot_see_users_project_or_roles_tab/



This is a link to [another document.](openstack-tutorial.md) This is a link to an [external page.](http://www.example.com/)
