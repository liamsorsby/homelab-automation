provider "proxmox" {
  pm_api_url          = var.proxmox_host["pm_api_url"]
  pm_api_token_id     = var.proxmox_host["pm_api_token_id"]
  pm_api_token_secret = var.proxmox_host["pm_api_token_secret"]
  pm_tls_insecure     = true
}

resource "proxmox_vm_qemu" "prox-vms" {
  count       = length(var.vm_configuration)
  name        = var.vm_configuration[count.index].hostname
  target_node = var.vm_configuration[count.index].target_pve_node
  vmid        = var.vmid + count.index
  full_clone  = true
  clone       = "cloud-init-focal"

  sockets  = 1
  vcpus    = var.vm_configuration[count.index].vcpus
  cores    = var.vm_configuration[count.index].cores
  memory   = var.vm_configuration[count.index].memory
  balloon  = var.vm_configuration[count.index].ballooning
  boot     = "c"
  bootdisk = "virtio0"

  scsihw = "virtio-scsi-pci"
  tags   = var.vm_configuration[count.index].tags

  onboot  = true
  agent   = 1
  cpu     = "kvm64"
  numa    = true
  hotplug = "network,disk,cpu,memory"

  cloudinit_cdrom_storage = "LVM"

  network {
    bridge = "vmbr0"
    model  = "virtio"
  }

  ipconfig0 = "ip=${var.vm_configuration[count.index].ipaddress}/24,gw=${cidrhost(format("%s/24", var.vm_configuration[count.index].ipaddress), 1)}"

  disks {
    virtio {
      virtio0 {
        disk {
          storage = "LVM"
          size    = "20"
        }
      }
    }
  }

  os_type = "cloud-init"

  ssh_user        = var.ssh_user
  ssh_private_key = file(var.ssh_keys["priv"])
  sshkeys         = file(var.ssh_keys["pub"])

  #creates ssh connection to check when the CT is ready for ansible provisioning
  connection {
    host        = var.vm_configuration[count.index].ipaddress
    user        = var.ssh_user
    private_key = file(var.ssh_keys["priv"])
    agent       = true
    timeout     = "3m"
  }

  #   # this stops the vm being rebooted all the time,
  #   # unfortunately this means sometimes we'll need a manual restart
  automatic_reboot = false

  provisioner "remote-exec" {
    # Leave this here so we know when to start with Ansible local-exec
    inline = ["echo 'Ready for provisioning'"]
  }
}
