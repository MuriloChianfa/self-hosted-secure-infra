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

resource "proxmox_vm_qemu" "core" {
  for_each = var.vms
  vmid = each.key

  target_node = var.proxmox_host
  name = each.value.name
  desc = <<EOF
  ## ${each.value.title}

  *Description*: ${each.value.description}

  ---
  EOF

  tags = each.value.tags
  pool = var.pool

  os_type = "cloud-init"
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

  ipconfig0 = "ip=${each.value.ip}${var.subnet_netmask},gw=${var.subnet_gateway}"
  network {
    model = "virtio"
    bridge = var.nic_name
    tag = var.nic_vlan
  }

  disks {
    ide {
      ide3 {
        cloudinit {
          storage = var.storage
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size = each.value.hdd
          cache = "none"
          storage = var.storage
          iothread = false
          backup = false
          discard = true
        }
      }
    }
  }

  ciuser = var.ciuser
  cipassword  = var.cipass
  sshkeys = var.allowedsshkey
  onboot = true
}
