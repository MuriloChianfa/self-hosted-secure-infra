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
variable "allowedsshkey" {
  description = "Allowed SSH public key to access ciuser"
  type = string
}

variable "proxmox_host" {
  description = "Hostname of Proxmox to apply"
  default = "pve"
  type = string
}
