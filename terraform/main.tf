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

module "core" {
  source = "./modules/core"
  api_url = var.api_url
  token_id = var.token_id
  token_secret = var.token_secret
  proxmox_host = var.proxmox_host
  vms = {
    100 = {"name" = "ca", "cores" = 1, "memory" = 512, "hdd" = 12},
    101 = {"name" = "ntp", "cores" = 1, "memory" = 512, "hdd" = 12},
    102 = {"name" = "nfs", "cores" = 2, "memory" = 768, "hdd" = 24},
    103 = {"name" = "ftp", "cores" = 2, "memory" = 768, "hdd" = 64},
    104 = {"name" = "ldap", "cores" = 2, "memory" = 1024, "hdd" = 32},
    105 = {"name" = "dns1", "cores" = 4, "memory" = 768, "hdd" = 18},
    106 = {"name" = "dns2", "cores" = 4, "memory" = 768, "hdd" = 18},
    107 = {"name" = "dhcp", "cores" = 1, "memory" = 1024, "hdd" = 18},
    108 = {"name" = "radius", "cores" = 2, "memory" = 1024, "hdd" = 24}
  }
}
