module.exports = {
  title: 'Openstack Cyber Cloud Project',
  tagline: '',
  url: 'https://your-docusaurus-test-site.com',
  baseUrl: '/',
  onBrokenLinks: 'throw',
  favicon: 'img/school-of-engineering-blue-horizon.svg',
  organizationName: 'USD Cyber Security', // Usually your GitHub org/user name.
  projectName: 'cyber-cloud-project-documentation', // Usually your repo name.
  themeConfig: {
    navbar: {
      title: 'Cyber Cloud Project Documentation',
      logo: {
        alt: 'My Site Logo',
        src: 'img/CCET-mark-2c.png',
      },
      items: [
        {
          to: 'docs/',
          activeBasePath: 'docs',
          label: 'Docs',
          position: 'left',
        },
        {to: 'blog', label: 'Blog', position: 'left'},
        {
          href: 'https://github.com/a-ridley/Cyber-Cloud-Project-Documentation',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Docs',
          items: [
            {
              label: 'Openstack Tutorial',
              to: 'docs/',
            },
            {
              label: 'Openstack Classroom Builder Tutorial',
              to: 'docs/creating-your-classroom',
            },
          ],
        },
        {
          title: 'Resources',
          items: [
            {
              label: 'Openstack Train Release',
              href: 'https://www.openstack.org/software/train/',
            },
            {
              label: 'Openstack API Documentation',
              href: 'https://docs.openstack.org/api-ref/identity/v3/',
            },
            {
              label: 'Ask Openstack',
              href: 'https://ask.openstack.org/en/questions/',
            },
          ],
        },
        {
          title: 'More',
          items: [
            {
              label: 'Blog',
              to: 'blog',
            },
            {
              label: 'GitHub',
              href: 'https://github.com/a-ridley/Cyber-Cloud-Project-Documentation',
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} CCP, Inc. Built with Docusaurus.`,
    },
  },
  presets: [
    [
      '@docusaurus/preset-classic',
      {
        docs: {
          sidebarPath: require.resolve('./sidebars.js'),
          // Please change this to your repo.
          editUrl:
            'https://github.com/facebook/docusaurus/edit/master/website/',
        },
        blog: {
          showReadingTime: true,
          // Please change this to your repo.
          editUrl:
            'https://github.com/facebook/docusaurus/edit/master/website/blog/',
        },
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      },
    ],
  ],
};
