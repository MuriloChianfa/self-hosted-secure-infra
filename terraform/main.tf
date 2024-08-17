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
  pm_log_file   = "terraform-plugin-proxmox.log"
  pm_log_levels = {
    _default    = "debug"
    _capturelog = ""
  }
}

resource "proxmox_vm_qemu" "blog_demo_test" {
  name = "test-vm-1"
  desc = "tf description"
  target_node = var.proxmox_host

  clone = var.template_name
  full_clone  = "false"

  # The destination resource pool for the new VM
  # pool = "core"

  vmid = 140
  os_type = "debian"
  agent = 1

  cpu = "x86-64-v2-AES"
  sockets = 1
  cores = 2
  memory = 2048

  network {
    model = "virtio"
    bridge = "vmbr0"
  }

  disks {
    scsi {
      scsi0 {
        disk {
          size = 32
          cache = "none"
          storage = "hdd-lvm"
          iothread = false
          backup = false
          discard = true
        }
      }
    }
  }
  boot = "order=scsi0"
  bootdisk = "scsi0"
}
