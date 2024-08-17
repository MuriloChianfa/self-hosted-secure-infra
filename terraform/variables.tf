variable "api_url" {
    default = "https://192.168.0.254:8006/api2/json"
}

variable "proxmox_host" {
    default = "pve"
}

variable "token_secret" {}
variable "token_id" {}

# separate between departments

variable "template_name" {
    default = "debian"
}

variable "nic_name" {
    default = "vmbr0"
}

variable "storage" {
    default = "hdd-lvm"
}

# variable "vlan_num" {
#     default = "place_vlan_number_here"
# }

