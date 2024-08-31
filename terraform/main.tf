terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.1-rc3"
    }
  }
}

provider "proxmox" {
  pm_api_url = var.api_url
  pm_api_token_id = var.token_id
  pm_api_token_secret = var.token_secret
  pm_tls_insecure = true
  pm_log_enable = true
  pm_debug = true
  pm_log_file = "terraform-plugin-proxmox.log"
}

resource "proxmox_pool" "core-pool" {
  poolid = "CORE"
  comment = "Resource pool for core infrastructure virtual machines"
}

module "core" {
  source = "./modules/infra"
  api_url = var.api_url
  token_id = var.token_id
  token_secret = var.token_secret
  proxmox_host = var.proxmox_host
  allowedsshkey = var.allowedsshkey
  template_name = "debian12-cloudinit-template"
  pool = "CORE"
  nic_vlan = 100
  storage = "nvme-lvm"
  subnet_netmask = "/26"
  subnet_gateway = "10.250.101.254"
  vms = {
    100 = {"name" = "ca", "cores" = 1, "memory" = 512, "hdd" = 12, "ip" = "10.250.101.243", "tags" = "core,crypto", "title" = "CA (Certificate Authority)", "description" = "Used to manage and issue digital certificates, which verify the identity of entities in a network, ensuring secure communication."},
    101 = {"name" = "ntp", "cores" = 1, "memory" = 512, "hdd" = 12, "ip" = "10.250.101.244", "tags" = "core,networking", "title" = "NTP (Network Time Protocol)", "description" = "Synchronizes the clocks of devices in a network to ensure consistent and accurate time across all systems."},
    102 = {"name" = "nfs", "cores" = 2, "memory" = 768, "hdd" = 24, "ip" = "10.250.101.245", "tags" = "core,networking,storage", "title" = "NFS (Network File System)", "description" = "Provides a way for multiple systems to share files over a network, allowing users to access and manage files on remote servers as if they were local."},
    103 = {"name" = "ftp", "cores" = 2, "memory" = 768, "hdd" = 64, "ip" = "10.250.101.246", "tags" = "core,networking,storage", "title" = "FTP (File Transfer Protocol)", "description" = "Enables the transfer of files between a client and a server over a network, often used for uploading or downloading files to/from a remote server."},
    104 = {"name" = "ldap", "cores" = 2, "memory" = 1024, "hdd" = 32, "ip" = "10.250.101.247", "tags" = "core,networking,auth", "title" = "LDAP (Lightweight Directory Access Protocol)", "description" = "Manages and provides access to directory services over a network, commonly used for storing user credentials and organizational data."},
    105 = {"name" = "dns1", "cores" = 2, "memory" = 768, "hdd" = 18, "ip" = "10.250.101.248", "tags" = "core,networking", "title" = "DNS (Domain Name System) Master", "description" = "Master server to translate human-readable domain names into IP addresses that computers use to identify each other on the network."},
    106 = {"name" = "dns2", "cores" = 2, "memory" = 768, "hdd" = 18, "ip" = "10.250.101.249", "tags" = "core,networking", "title" = "DNS (Domain Name System) Slave", "description" = "Slave server to translate human-readable domain names into IP addresses that computers use to identify each other on the network."},
    107 = {"name" = "dhcp", "cores" = 1, "memory" = 512, "hdd" = 18, "ip" = "10.250.101.250", "tags" = "core,networking", "title" = "DHCP (Dynamic Host Configuration Protocol)", "description" = "Automatically assigns IP addresses and network configurations to devices in a network, ensuring that each device can communicate without manual setup."},
    108 = {"name" = "radius", "cores" = 2, "memory" = 1024, "hdd" = 24, "ip" = "10.250.101.251", "tags" = "core,networking,auth", "title" = "RADIUS (Remote Authentication Dial-In User Service)", "description" = "Provides centralized authentication, authorization, and accounting for users who connect and use a network service, often used in remote access situations."}
  }
}

resource "proxmox_pool" "support-pool" {
  poolid = "SUPPORT"
  comment = "Resource pool for support infrastructure virtual machines"
}

module "support" {
  source = "./modules/infra"
  api_url = var.api_url
  token_id = var.token_id
  token_secret = var.token_secret
  proxmox_host = var.proxmox_host
  allowedsshkey = var.allowedsshkey
  template_name = "debian12-cloudinit-template"
  pool = "SUPPORT"
  nic_vlan = 200
  storage = "nvme-lvm"
  subnet_netmask = "/27"
  subnet_gateway = "172.19.242.62"
  vms = {
    200 = {"name" = "oscap", "cores" = 4, "memory" = 2048, "hdd" = 48, "ip" = "172.19.242.45", "tags" = "support,security", "title" = "OpenSCAP", "description" = "A tool used for security compliance checking and vulnerability scanning based on the OpenSCAP framework. It helps ensure that systems meet security standards by automating audits and checks."},
    201 = {"name" = "openvas", "cores" = 8, "memory" = 8192, "hdd" = 128, "ip" = "172.19.242.46", "tags" = "support,security", "title" = "OpenVAS", "description" = "Vulnerability scanning tool that identifies security vulnerabilities in systems and networks. It's often used in penetration testing and security assessments."},
    202 = {"name" = "ndpmon", "cores" = 2, "memory" = 768, "hdd" = 24, "ip" = "172.19.242.47", "tags" = "support,networking,security", "title" = "NDPMon", "description" = "Monitors Neighbor Discovery Protocol (NDP) messages in IPv6 networks. It's used for detecting potential network issues and security threats, such as rogue routers or address spoofing."},
    203 = {"name" = "ettercap", "cores" = 2, "memory" = 768, "hdd" = 32, "ip" = "172.19.242.48", "tags" = "support,networking,security", "title" = "Ettercap", "description" = "A network security tool for intercepting, analyzing, and manipulating network traffic. It's often used in network penetration testing and for conducting man-in-the-middle attacks to test network defenses."},
    204 = {"name" = "arpwatch", "cores" = 2, "memory" = 768, "hdd" = 24, "ip" = "172.19.242.49", "tags" = "support,networking,security", "title" = "Arpwatch", "description" = "Monitors Ethernet and IP address mappings and logs changes. It helps in detecting ARP spoofing and other network anomalies by tracking MAC-to-IP address bindings."},
    205 = {"name" = "deauthalyzer", "cores" = 2, "memory" = 768, "hdd" = 18, "ip" = "172.19.242.50", "tags" = "support,networking,security,wifi", "title" = "Deauthalyzer", "description" = "A tool used for detecting and analyzing Wi-Fi deauthentication attacks. It helps in identifying attempts to disrupt or hijack wireless network connections, often used in Wi-Fi security testing."},
  }
}

resource "proxmox_pool" "tools-pool" {
  poolid = "TOOLS"
  comment = "Resource pool for tools infrastructure virtual machines"
}

module "tools" {
  source = "./modules/infra"
  api_url = var.api_url
  token_id = var.token_id
  token_secret = var.token_secret
  proxmox_host = var.proxmox_host
  allowedsshkey = var.allowedsshkey
  template_name = "debian12-cloudinit-template"
  pool = "TOOLS"
  nic_vlan = 300
  storage = "nvme-lvm"
  subnet_netmask = "/28"
  subnet_gateway = "192.168.175.30"
  vms = {
    300 = {"name" = "awx", "cores" = 4, "memory" = 6128, "hdd" = 48, "ip" = "192.168.175.19", "tags" = "tools,security", "title" = "Ansible AWX", "description" = "An open-source web-based user interface and API that provides management and monitoring for Ansible automation. AWX helps to simplify automation tasks, making it easier to deploy and manage infrastructure and applications."},
    301 = {"name" = "ntop", "cores" = 4, "memory" = 4096, "hdd" = 128, "ip" = "192.168.175.20", "tags" = "tools,networking,monitor", "title" = "NTOP", "description" = "A network monitoring tool that provides detailed visibility into network traffic, performance, and usage. It's often used for real-time traffic analysis and network troubleshooting."},
    302 = {"name" = "squid", "cores" = 4, "memory" = 768, "hdd" = 24, "ip" = "192.168.175.21", "tags" = "tools,networking", "title" = "Proxy Squid", "description" = "A caching and forwarding proxy server that optimizes web traffic by storing frequently accessed content and reducing bandwidth usage. It also provides security features like content filtering and access control."},
    303 = {"name" = "snort", "cores" = 6, "memory" = 768, "hdd" = 48, "ip" = "192.168.175.22", "tags" = "tools,networking,security", "title" = "Snort", "description" = "An open-source network intrusion detection and prevention system (IDS/IPS). It monitors network traffic in real time, identifying and blocking potential threats based on predefined rules."},
    304 = {"name" = "zabbix", "cores" = 12, "memory" = 768, "hdd" = 96, "ip" = "192.168.175.23", "tags" = "tools,networking,monitor", "title" = "Zabbix", "description" = "A powerful open-source monitoring tool that tracks the performance and availability of IT infrastructure, including servers, network devices, and applications. Zabbix provides alerts and reporting to ensure systems are running smoothly."},
    305 = {"name" = "graylog", "cores" = 4, "memory" = 768, "hdd" = 32, "ip" = "192.168.175.24", "tags" = "tools,monitor,logs", "title" = "Graylog", "description" = "A centralized log management platform that aggregates, analyzes, and searches through large amounts of log data. It helps in troubleshooting, security monitoring, and gaining insights from system logs."},
    306 = {"name" = "stirling", "cores" = 1, "memory" = 768, "hdd" = 18, "ip" = "192.168.175.25", "tags" = "tools,crypto", "title" = "Stirling", "description" = "A tool used for forensic analysis and network traffic monitoring. It helps in capturing and analyzing network data for security and troubleshooting purposes."},
    307 = {"name" = "bitwarden", "cores" = 2, "memory" = 4096, "hdd" = 32, "ip" = "192.168.175.26", "tags" = "tools,security,crypto", "title" = "Bitwarden", "description" = "A secure open-source password manager that stores and manages credentials. It offers encryption and multi-device synchronization, ensuring that passwords are safe and accessible across platforms."},
  }
}

resource "proxmox_pool" "company-pool" {
  poolid = "COMPANY"
  comment = "Resource pool for company infrastructure virtual machines"
}

module "company" {
  source = "./modules/infra"
  api_url = var.api_url
  token_id = var.token_id
  token_secret = var.token_secret
  proxmox_host = var.proxmox_host
  allowedsshkey = var.allowedsshkey
  template_name = "debian12-cloudinit-template"
  pool = "COMPANY"
  nic_vlan = 400
  storage = "nvme-lvm"
  subnet_netmask = "/28"
  subnet_gateway = "192.168.12.142"
  vms = {
    400 = {"name" = "docs", "cores" = 1, "memory" = 768, "hdd" = 48, "ip" = "192.168.12.133", "tags" = "company,website", "title" = "BookStack", "description" = "A simple, self-hosted wiki platform designed for organizing and storing information. It's often used by teams to create and manage documentation, knowledge bases, or manuals."},
    401 = {"name" = "demo", "cores" = 6, "memory" = 4096, "hdd" = 64, "ip" = "192.168.12.134", "tags" = "company,website", "title" = "Demonstration App", "description" = "A demonstration or test application used to showcase the features and functionality of a company's products or services. This VM is typically used for presentations, training, or testing purposes."},
    402 = {"name" = "website", "cores" = 4, "memory" = 2048, "hdd" = 32, "ip" = "192.168.12.135", "tags" = "company,website", "title" = "Company Website", "description" = "The main web server hosting the company's public-facing website. This VM is responsible for delivering the company's content and services to users via the internet."},
    403 = {"name" = "archive", "cores" = 1, "memory" = 768, "hdd" = 32, "ip" = "192.168.12.136", "tags" = "company,website", "title" = "Company Packages", "description" = "A repository server that hosts package files like .deb, .rpm. This VM allows for the distribution and management of custom or third-party software packages within the organization."},
    404 = {"name" = "registry", "cores" = 2, "memory" = 1024, "hdd" = 86, "ip" = "192.168.12.137", "tags" = "company,website,docker", "title" = "Private Docker Registry", "description" = "A private Docker registry used to store and distribute Docker container images. It allows teams to share, version, and deploy containerized applications in a controlled environment."},
    405 = {"name" = "owncloud", "cores" = 2, "memory" = 2048, "hdd" = 128, "ip" = "192.168.12.138", "tags" = "company,website,storage", "title" = "OwnCloud", "description" = "A self-hosted cloud storage platform that allows users to store and sync files across devices. It offers features similar to commercial cloud storage services, but with more control and privacy."},
  }
}

resource "proxmox_pool" "development-pool" {
  poolid = "DEVELOPMENT"
  comment = "Resource pool for development infrastructure virtual machines"
}

module "development" {
  source = "./modules/infra"
  api_url = var.api_url
  token_id = var.token_id
  token_secret = var.token_secret
  proxmox_host = var.proxmox_host
  allowedsshkey = var.allowedsshkey
  template_name = "debian12-cloudinit-template"
  pool = "DEVELOPMENT"
  nic_vlan = 500
  storage = "nvme-lvm"
  subnet_netmask = "/28"
  subnet_gateway = "10.32.15.14"
  vms = {
    500 = {"name" = "ci", "cores" = 8, "memory" = 4096, "hdd" = 64, "ip" = "10.32.15.5", "tags" = "development,automation", "title" = "GH Runners", "description" = "GitHub Runners are virtual machines that execute GitHub Actions workflows. They run CI/CD pipelines, testing, and deployments, and can be self-hosted for custom environments."},
    501 = {"name" = "cd", "cores" = 4, "memory" = 4096, "hdd" = 64, "ip" = "10.32.15.6", "tags" = "development,automation", "title" = "Packer", "description" = "A tool for automating the creation of machine images (e.g., OVF, Docker images) for multiple platforms from a single source configuration. This VM is used to build and distribute consistent environments."},
    502 = {"name" = "clair", "cores" = 4, "memory" = 2048, "hdd" = 32, "ip" = "10.32.15.7", "tags" = "development,website", "title" = "Clair", "description" = "An open-source static security scanner for container images. It analyzes Docker images to find vulnerabilities in the packages included in the container."},
    503 = {"name" = "sentry", "cores" = 16, "memory" = 12512, "hdd" = 128, "ip" = "10.32.15.8", "tags" = "development,website", "title" = "Sentry", "description" = "A real-time error tracking tool that monitors applications for crashes and exceptions, providing detailed reports to help developers identify and fix issues."},
    504 = {"name" = "staging", "cores" = 6, "memory" = 4096, "hdd" = 64, "ip" = "10.32.15.9", "tags" = "development,website,docker", "title" = "Staging branch", "description" = "A staging environment that mirrors the production environment for testing new features, bug fixes, and updates before they are deployed to the live system."},
    505 = {"name" = "zaproxy", "cores" = 4, "memory" = 2048, "hdd" = 32, "ip" = "10.32.15.10", "tags" = "development,website,storage", "title" = "ZAProxy", "description" = "An open-source web application security scanner used to find vulnerabilities in web applications. It intercepts and analyzes HTTP/HTTPS traffic to detect potential security issues."},
    506 = {"name" = "registry", "cores" = 2, "memory" = 1024, "hdd" = 86, "ip" = "10.32.15.11", "tags" = "development,website,storage", "title" = "Docker Registry", "description" = "A public Docker registry used to store and manage Docker images within the organization, facilitating the sharing and deployment of containerized applications."},
    507 = {"name" = "selenium", "cores" = 4, "memory" = 2048, "hdd" = 48, "ip" = "10.32.15.12", "tags" = "development,website,storage", "title" = "Selenium", "description" = "A suite of tools for automating web browsers, primarily used for testing web applications. It allows developers to write scripts that simulate user interactions with a web page."},
    508 = {"name" = "sonarqube", "cores" = 4, "memory" = 2048, "hdd" = 48, "ip" = "10.32.15.13", "tags" = "development,website,storage", "title" = "SonarQube", "description" = "A code quality management platform that continuously inspects codebases for bugs, vulnerabilities, and code smells. It helps maintain high code standards and improves the overall maintainability of projects."},
  }
}

resource "proxmox_pool" "dmz-pool" {
  poolid = "DMZ"
  comment = "Resource pool for dmz infrastructure virtual machines"
}

module "dmz" {
  source = "./modules/infra"
  api_url = var.api_url
  token_id = var.token_id
  token_secret = var.token_secret
  proxmox_host = var.proxmox_host
  allowedsshkey = var.allowedsshkey
  template_name = "debian12-cloudinit-template"
  pool = "DMZ"
  nic_vlan = 900
  storage = "nvme-lvm"
  subnet_netmask = "/28"
  subnet_gateway = "172.25.31.78"
  vms = {
    900 = {"name" = "ns1", "cores" = 2, "memory" = 768, "hdd" = 18, "ip" = "172.25.31.68", "tags" = "dmz,networking", "title" = "DNS Name Server Master", "description" = "The master DNS server responsible for translating domain names into IP addresses. It helps direct internet traffic by resolving queries for domain names."},
    901 = {"name" = "ns2", "cores" = 2, "memory" = 768, "hdd" = 18, "ip" = "172.25.31.69", "tags" = "dmz,networking", "title" = "DNS Name Server Slave", "description" = "The slave DNS server responsible for translating domain names into IP addresses. It helps direct internet traffic by resolving queries for domain names if the primary server fails."},
    902 = {"name" = "sni", "cores" = 8, "memory" = 2048, "hdd" = 24, "ip" = "172.25.31.70", "tags" = "dmz,website", "title" = "Clair", "description" = "A VM configured to handle SSL/TLS requests with support for SNI, which allows multiple SSL certificates to be hosted on a single IP address by indicating the hostname at the start of the handshake."},
    903 = {"name" = "vpn", "cores" = 3, "memory" = 1024, "hdd" = 24, "ip" = "172.25.31.71", "tags" = "dmz,networking", "title" = "Sentry", "description" = "Provides secure and encrypted connections over a public network. This VM is typically used to create a private network that can be accessed remotely, ensuring secure communication for users and devices."},
    904 = {"name" = "imap", "cores" = 2, "memory" = 1024, "hdd" = 64, "ip" = "172.25.31.72", "tags" = "dmz,networking,email", "title" = "Staging branch", "description" = "A mail server that allows users to access and manage their email from multiple devices. IMAP keeps emails on the server, allowing synchronization across devices."},
    905 = {"name" = "smtp", "cores" = 2, "memory" = 1024, "hdd" = 64, "ip" = "172.25.31.73", "tags" = "dmz,networking,email", "title" = "ZAProxy", "description" = "A server responsible for sending and receiving email messages. It handles the outbound mail delivery and can also be configured to receive incoming messages."},
    906 = {"name" = "bastion", "cores" = 12, "memory" = 2048, "hdd" = 46, "ip" = "172.25.31.74", "tags" = "dmz,networking,security", "title" = "Docker Registry", "description" = "A hardened server used as a gateway to access other machines within a network. It acts as a secure entry point, typically used for administrative purposes to connect to resources in a private network."},
    907 = {"name" = "honeypot", "cores" = 2, "memory" = 1024, "hdd" = 32, "ip" = "172.25.31.75", "tags" = "dmz,security", "title" = "Selenium", "description" = "A security-focused VM designed to attract and detect attackers by mimicking vulnerable systems. It's used to monitor malicious activity and gather information about potential threats."},
  }
}

module "tests" {
  source = "./modules/infra"
  api_url = var.api_url
  token_id = var.token_id
  token_secret = var.token_secret
  proxmox_host = var.proxmox_host
  allowedsshkey = var.allowedsshkey
  template_name = "debian12-cloudinit-template"
  pool = "DMZ"
  nic_vlan = 900
  storage = "nvme-lvm"
  subnet_netmask = "/28"
  subnet_gateway = "172.25.31.78"
  vms = {
    908 = {"name" = "tests", "cores" = 8, "memory" = 8256, "hdd" = 46, "ip" = "172.25.31.76", "tags" = "dmz,tests", "title" = "Tests", "description" = "Simple VM to make some Ansible playbooks tests"},
  }
}
