module.exports = {
  someSidebar: {
    'Welcome': ['openstack-tutorial', 'power-scripts'],
    'OpenStack Classroom Builder': [ 
      {
        type: 'category',
        label: 'Production',
        items: ['run-classroom-builder-in-production']
      },
      {
        type: 'category',
        label: 'Tutorial',
        items: ['creating-your-classroom', 'example-classroom-file']
      },
      {
      type: 'category',
      label: 'Templates',
      items: ['tutorial.classroom.yaml']
      }
  ],
    Docusaurus: ['doc1', 'how-to-deploy'],
    Permissions: ['oslo-policy'],
    Diagrams: ['diagrams'],
    Troubleshooting: ['startup-service-notes', 'network-notes', 'bug-cannot-delete-network', 'bug-could-not-kvm', 'bug-crazy-hypervisor', 'bug-not-receiving-dhcp', 'bug-rabbitmq-unreachable', 'bug-too-many-connections', 'bug-db-too-many-open-files', 'diagnosis-tips'],
    Maintenance: ['dashboard-maintenance', 'active-maintenance-script', 'instance-maintenance', 'maintaining-hosts'],
    'Playbooks': [
      {
        type: 'category',
        label: 'Nodes',
        items: ['controller-node-playbook', 'compute-node-playbook', 'block-node-playbook' ]
      },
      {
        type: 'category',
        label: 'Ansible Guide',
        items: ['ansible-playbooks']
      },
    ],
    'How-To': ['deploy-from-snapshot', 'qcow2-techniques', 'getting-files'],
    'Metadata Server': ['metadata-server'],
    'Backup': ['backup'],
    Features: ['mdx'],
  },
};
