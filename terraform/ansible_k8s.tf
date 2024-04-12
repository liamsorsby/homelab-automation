resource "null_resource" "ansible-k8s" {
  depends_on = [null_resource.ansible-base]

  provisioner "local-exec" {
    working_dir = "../ansible/k8s"
    command     = "ansible-playbook k8s.yaml -u ${var.ssh_user} --key-file ${var.ssh_keys["priv"]} -i ../inventory"
  }

  triggers = {
    always_run = timestamp()
  }
}
