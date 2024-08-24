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

variable "nic_vlan" {
  description = "Network interface card virtual local area network"
  default = "100"
  type = string
}

variable "storage" {
  description = "Storage for the VM disk"
  default = "hdd-lvm"
  type = string
}

variable "ciuser" {
  description = "User to use cloud-init driver"
  default = "root"
  type = string
}

variable "cipass" {
  description = "Password of to user to use cloud-init driver"
  default = "toor"
  type = string
}

variable "pool" {
  description = "Resource pool for this section"
  default = "CORE"
  type = string
}

variable "subnet_netmask" {
  description = "Netmask of the subnet to this section"
  default = "/24"
  type = string
}

variable "subnet_gateway" {
  description = "Address of the gateway to this subnet"
  default = "192.168.0.1"
  type = string
}

variable "vms" {
  description = "The list of virtual machines to provision"
  default = {}
}
