variable "pve_node" {
  type        = string
  description = "Desired PVE node to install onto"
  default     = "pve1"
}

variable "environment" {
  type        = string
  description = "environment"
}

variable "iso_file" {
  type        = string
  description = "ISO file name"
  default     = "SynologyNFS:iso/debian-12.5.0-amd64-netinst.iso"
}

variable "proxmox_host" {
  type = map(any)
  default = {
    pm_api_url          = "https://192.168.7.115:8006/api2/json/"
    pm_api_token_id     = "root@pam"
    pm_api_token_secret = "pve"
  }
}

variable "vm_configuration" {
  type = list(object({
    hostname : string
    ipaddress : string
    target_pve_node : string
    cores : number
    vcpus : number
    memory : number
    ballooning : number
    tags : string
  }))

  default = [
    {
      hostname : "k8smaster01",
      ipaddress : "192.168.7.6",
      target_pve_node : "pve1",
      cores : 4,
      vcpus : 4,
      memory : 4096,
      ballooning : 4096,
      tags : "k8s,k8smaster"
    },
    {
      hostname : "k8sworker01",
      ipaddress : "192.168.7.7",
      target_pve_node : "pve2",
      cores : 3,
      vcpus : 3,
      memory : 4096,
      ballooning : 4096,
      tags : "k8s,k8sworker"
    },
    {
      hostname : "k8sworker02",
      ipaddress : "192.168.7.8",
      target_pve_node : "pve1",
      cores : 3,
      vcpus : 3,
      memory : 4096,
      ballooning : 4096,
      tags : "k8s,k8sworker"
    },
    {
      hostname : "k8sworker03",
      ipaddress : "192.168.7.9",
      target_pve_node : "pve2",
      cores : 3,
      vcpus : 3,
      memory : 4096,
      ballooning : 4096,
      tags : "k8s,k8sworker"
    },
    {
      hostname : "k8sworker04",
      ipaddress : "192.168.7.10",
      target_pve_node : "pve1",
      cores : 3,
      vcpus : 3,
      memory : 4096,
      ballooning : 4096,
      tags : "k8s,k8sworker"
    },
    {
      hostname : "dnsmaster01",
      ipaddress : "192.168.7.11",
      target_pve_node : "pve2",
      cores : 3,
      vcpus : 3,
      memory : 4096,
      ballooning : 4096,
      tags : "dns,master"
    },
    {
      hostname : "dnsslave01",
      ipaddress : "192.168.7.12",
      target_pve_node : "pve2",
      cores : 2,
      vcpus : 2,
      memory : 4096,
      ballooning : 4096,
      tags : "dns,slave"
    },
    {
      hostname : "dnsslave02",
      ipaddress : "192.168.7.13",
      target_pve_node : "pve1",
      cores : 2,
      vcpus : 2,
      memory : 4096,
      ballooning : 4096,
      tags : "dns,slave"
    }
  ]
}

variable "vmid" {
  type        = number
  description = "initial vm id"
  default     = 200
}

variable "ssh_user" {
  type        = string
  description = "username"
  default     = "ubuntu"
}

variable "ssh_keys" {
  type = map(any)
  default = {
    pub  = "~/.ssh/id_ed25519.pub"
    priv = "~/.ssh/id_ed25519"
  }
}

variable "ssh_password" {}
