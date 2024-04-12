resource "null_resource" "ansible-dns" {
  depends_on = [null_resource.ansible-base]

  provisioner "local-exec" {
    working_dir = "../ansible/dns"
    command     = "ansible-playbook main.yaml -u ${var.ssh_user} --key-file ${var.ssh_keys["priv"]} -i ../inventory"
  }

  triggers = {
    always_run = timestamp()
  }
}
