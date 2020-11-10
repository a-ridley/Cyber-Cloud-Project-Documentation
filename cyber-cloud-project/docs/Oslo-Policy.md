---
id: oslo-policy
title: Oslo-Policy (Permissions)
---

Each service in openstack has their own set of policies and they use the oslo policy engine to define policy rules. These poliices are taken straight from source code. Therefore, if there is any need to edit the default policies for each service they must be generated. 

In order to generate the default policy file for each service you must run the following command on the Controller node. **(Note: This only has to be done once.)**

        oslopolicy-policy-upgrade \
        --config-file/etc/keystone/keystone.conf \
        --format json --namespace keystone \
        --output-file keystone_policy_2.json \
        --policy keystone_policy.json

Horizon implements policies by using copies of the policy files found in a service's source code. However, if you generate default policies using the above command you are going to need to copy each service's policy.json file to a location Horizon can find them.

 According to [Openstack Horizon Settings Reference,](https://docs.openstack.org/horizon/latest/configuration/settings.html) we can find and edit Horizons' settings at:
 
  `/usr/share/openstack-dashboard/openstack_dashboard/local/local_settings.py`. 
 
 However, once looking at the configuration file there is a comment stating the following:

![image info](/img/defaultsdotpy-NOTE.png)

Therefore, we will make changes  in `openstack_dashboard/defaults.py`.

Inside `defaults.py` you will notice there is a line that says: 
        # Path to directory containing policy.json files
        POLICY_FILES_PATH = os.path.join(_get_root_path(), "conf")
`conf` is the folder that Horizon is going to be looking for the policy files.

In order for Horizon to be able to interpret these policy files we must first ensure that `defaults.py` at `/usr/share/openstack-dashboard/openstack_dashboard` has the following:

        POLICY_FILES = {
            'identity': 'keystone_policy.json',
            'compute': 'nova_policy.json',
            'volume':'cinder_policy.json',
            'image': 'glance_policy.json',
            'network': 'neutron_policy.json'
        }

and second, copy each services policy.json files we generated earlier to 

`/usr/share/openstack-dashboard/openstack_dashboard/conf/`

Sources: [Horizon Policy Enforcement (RBAC: Role Based Access Control)](https://docs.openstack.org/horizon/latest/contributor/topics/policy.html)



This is a link to [another document.](openstack-tutorial.md) This is a link to an [external page.](http://www.example.com/)
