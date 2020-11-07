module.exports = {
  someSidebar: {
    Docusaurus: ['doc1', 'how-to-deploy'],
    Permissions: ['oslo-policy'],
    'Project Setup': ['power-scripts', 'create-users-script'],
    Diagrams: ['diagrams'],
    Troubleshooting: ['startup-service-notes', 'network-notes', 'bug-cannot-delete-network', 'bug-could-not-kvm', 'bug-crazy-hypervisor', 'bug-not-receiving-dhcp', 'bug-rabbitmq-unreachable', 'bug-too-many-connections', 'diagnosis-tips'],
    Maintenance: ['dashboard-maintenance', 'active-maintenance-script', 'instance-maintenance', 'maintaining-hosts'],
    'Node Playbooks': [
      {
        type: 'category',
        label: 'Controller',
        items: ['controller-node-playbook']
      },
      {
        type: 'category',
        label: 'Compute',
        items: ['compute-node-playbook']
      },
      {
        type: 'category',
        label: 'Block',
        items: ['block-node-playbook']
      }
    ],
    'How-To': ['deploy-from-snapshot', 'qcow2-techniques', 'getting-files'],
    'Metadata Server': ['metadata-server'],
    'Backup': ['backup'],
    Features: ['mdx'],
  },
};
