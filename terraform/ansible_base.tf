// this is inplace to ensure that when the vm reboots it has enough time to boot up
// This is no longer required as I've disabled the auto reboot
resource "time_sleep" "wait_15_seconds" {
  depends_on = [proxmox_vm_qemu.prox-vms]

  create_duration = "15s"

  triggers = {
    always_run = timestamp()
  }
}

resource "null_resource" "ansible-base" {
  depends_on = [time_sleep.wait_15_seconds]

  provisioner "local-exec" {
    working_dir = "../ansible/base"
    command     = "ansible-playbook base.yaml -u ${var.ssh_user} --key-file ${var.ssh_keys["priv"]} -i ../inventory"
  }

  triggers = {
    always_run = timestamp()
  }
}
