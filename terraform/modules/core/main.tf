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

resource "proxmox_vm_qemu" "core" {
  for_each = var.vms
  vmid = each.key

  target_node = var.proxmox_host
  name = each.value.name
  desc = <<EOF
  asd
  EOF

  tags = "core"
  pool = "CORE"

  clone = var.template_name
  full_clone  = "false"

  cpu = "x86-64-v2-AES"
  sockets = 1
  cores = each.value.cores

  memory = each.value.memory
  balloon = 512

  boot = "order=scsi0"
  bootdisk = "scsi0"
  agent = 1

  network {
    model = "virtio"
    bridge = "vmbr0"
  }

  disks {
    scsi {
      scsi0 {
        disk {
          size = each.value.memory
          cache = "none"
          storage = "hdd-lvm"
          iothread = false
          backup = false
          discard = true
        }
      }
    }
  }
}
