variable "api_url" {
  description = "Proxmox API URL"
  type = string
}

variable "token_id" {
  description = "Proxmox API Token ID"
  type = string
}

variable "token_secret" {
  description = "Proxmox API Token Secret"
  type = string
}

variable "proxmox_host" {
  description = "Hostname of Proxmox to apply"
  default = "pve"
  type = string
}

variable "template_name" {
    description = "Template name for VM cloning"
    default = "debian"
    type = string
}

variable "nic_name" {
    description = "Network interface card name"
    default = "vmbr0"
    type = string
}

variable "storage" {
    description = "Storage for the VM disk"
    default = "hdd-lvm"
    type = string
}
