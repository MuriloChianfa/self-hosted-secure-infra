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
  template_name = "debian12-cloudinit-template"
  pool = "CORE"
  nic_vlan = 100
  storage = "nvme-lvm"
  subnet_netmask = "/28"
  subnet_gateway = "10.250.101.254"
  vms = {
    100 = {"name" = "ca", "cores" = 1, "memory" = 512, "hdd" = 12, "ip" = "10.250.101.243", "tags" = "core,crypto", "title" = "CA (Certificate Authority)", "description" = "Used to manage and issue digital certificates, which verify the identity of entities in a network, ensuring secure communication."},
    101 = {"name" = "ntp", "cores" = 1, "memory" = 512, "hdd" = 12, "ip" = "10.250.101.244", "tags" = "core,networking", "title" = "NTP (Network Time Protocol)", "description" = "Synchronizes the clocks of devices in a network to ensure consistent and accurate time across all systems."},
    102 = {"name" = "nfs", "cores" = 2, "memory" = 768, "hdd" = 24, "ip" = "10.250.101.245", "tags" = "core,networking,storage", "title" = "NFS (Network File System)", "description" = "Provides a way for multiple systems to share files over a network, allowing users to access and manage files on remote servers as if they were local."},
    103 = {"name" = "ftp", "cores" = 2, "memory" = 768, "hdd" = 64, "ip" = "10.250.101.246", "tags" = "core,networking,storage", "title" = "FTP (File Transfer Protocol)", "description" = "Enables the transfer of files between a client and a server over a network, often used for uploading or downloading files to/from a remote server."},
    104 = {"name" = "ldap", "cores" = 2, "memory" = 1024, "hdd" = 32, "ip" = "10.250.101.247", "tags" = "core,networking,auth", "title" = "LDAP (Lightweight Directory Access Protocol)", "description" = "Manages and provides access to directory services over a network, commonly used for storing user credentials and organizational data."},
    105 = {"name" = "dns1", "cores" = 4, "memory" = 768, "hdd" = 18, "ip" = "10.250.101.248", "tags" = "core,networking", "title" = "DNS (Domain Name System) Master", "description" = "Master server to translate human-readable domain names into IP addresses that computers use to identify each other on the network."},
    106 = {"name" = "dns2", "cores" = 4, "memory" = 768, "hdd" = 18, "ip" = "10.250.101.249", "tags" = "core,networking", "title" = "DNS (Domain Name System) Slave", "description" = "Slave server to translate human-readable domain names into IP addresses that computers use to identify each other on the network."},
    107 = {"name" = "dhcp", "cores" = 1, "memory" = 512, "hdd" = 18, "ip" = "10.250.101.250", "tags" = "core,networking", "title" = "DHCP (Dynamic Host Configuration Protocol)", "description" = "Automatically assigns IP addresses and network configurations to devices in a network, ensuring that each device can communicate without manual setup."},
    108 = {"name" = "radius", "cores" = 2, "memory" = 1024, "hdd" = 24, "ip" = "10.250.101.251", "tags" = "core,networking,auth", "title" = "RADIUS (Remote Authentication Dial-In User Service)", "description" = "Provides centralized authentication, authorization, and accounting for users who connect and use a network service, often used in remote access situations."}
  }
}
