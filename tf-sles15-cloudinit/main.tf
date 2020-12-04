data "template_file" "repositories" {
  template = file("cloud-init/repository.tpl")
  count    = length(var.repositories)

  vars = {
    repository_url  = element(values(var.repositories), count.index)
    repository_name = element(keys(var.repositories), count.index)
  }
}

data "template_file" "register_scc" {
  template = file("cloud-init/register-scc.tpl")

  vars = {
    sle_registry_code = var.sle_registry_code
  }
}

data "template_file" "register_rmt" {
  template = file("cloud-init/register-rmt.tpl")

  vars = {
    rmt_server_name = var.rmt_server_name
  }
}

data "template_file" "commands" {
  template = file("cloud-init/commands.tpl")
  count    = join("", var.packages) == "" ? 0 : 1

  vars = {
    packages = join(", ", var.packages)
  }
}

data "template_file" "cloud-init" {
  template = file("cloud-init/common.tpl")

  vars = {
    authorized_keys = join("\n", formatlist("  - %s", var.authorized_keys))
    repositories    = join("\n", data.template_file.repositories.*.rendered)
    register_scc    = join("\n", data.template_file.register_scc.*.rendered)
    register_rmt    = join("\n", data.template_file.register_rmt.*.rendered)
    commands        = join("\n", data.template_file.commands.*.rendered)
    username        = var.username
    password        = var.password
    ntp_servers     = join("\n", formatlist("    - %s", var.ntp_servers))
  }
}

resource "libvirt_volume" "tf-sle15" {
  name           = "${var.stack_name}-volume"
  pool           = var.pool
  size           = var.disk_size
  base_volume_id = libvirt_volume.img.id
}

resource "libvirt_cloudinit_disk" "tf-sle15" {
  name      = "${var.stack_name}-cloudinit-disk"
  pool      = var.pool
  user_data = data.template_file.cloud-init.rendered
}

resource "libvirt_domain" "tf-sle15" {
  name       = "${var.stack_name}-domain"
  memory     = var.memory
  vcpu       = var.vcpu
  cloudinit  = libvirt_cloudinit_disk.tf-sle15.id

  cpu = {
    mode = "host-passthrough"
  }

  disk {
    volume_id = libvirt_volume.tf-sle15.id
  }

  network_interface {
    network_id     = libvirt_network.network.id
    addresses      = [cidrhost(var.network_cidr, 250)]
    wait_for_lease = true
  }

  graphics {
    type        = "vnc"
    listen_type = "address"
  }
}
resource "null_resource" "wait_cloudinit" {
  depends_on = [libvirt_domain.tf-sle15]

  connection {
    host     = libvirt_domain.tf-sle15.network_interface.0.addresses.0
    user     = var.username
    password = var.password
    type     = "ssh"
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait > /dev/null",
    ]
  }
}

resource "null_resource" "reboot" {
  depends_on = [null_resource.wait_cloudinit]

  provisioner "local-exec" {
    environment = {
      user = var.username
      host = libvirt_domain.tf-sle15.network_interface.0.addresses.0
    }

    command = <<EOT
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $user@$host sudo reboot || :
# wait for ssh ready after reboot
until nc -zv $host 22; do sleep 5; done
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -oConnectionAttempts=60 $user@$host /usr/bin/true
EOT

  }
}
