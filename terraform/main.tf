# Provider configuration for VirtualBox
provider "virtualbox" {
  # Assuming VirtualBox and Terraform are both installed on officepc
  vboxmanage_path = "/usr/bin/VBoxManage"
}

terraform {
  required_providers {
    virtualbox = {
      source  = "local/virtualbox"
      version = "6.1.50"
    }
  }
}

# Use SSH provisioner to control VirtualBox on officepc
provider "null" {}

# Define the SSH connection to the officepc
resource "null_resource" "remote_virtualbox" {
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = "192.168.1.101"  # IP address of officepc
      user        = "daniel"  # Replace with your SSH username
      private_key = file("private/key")  # Path to your SSH private key
    }

    # Command to trigger Terraform on the remote machine
    inline = [
      "cd /home/daniel/terraform/ && terraform init && terraform apply -auto-approve"
    ]
  }
}

# Define a VirtualBox VM resource on officepc
resource "virtualbox_vm" "debian_vm" {
  name      = "Debian_VM"
  ostype    = "Debian_64"
  cpus      = 2
  memory    = 2048

  image = "/home/daniel/Downloads/debian-12.7.0-amd64-netinst.iso"

  vrde {
    enabled = true
    port    = 5000
  }

  network_adapter {
    type           = "bridged"
    host_interface = "en0"
  }

  storage {
    name         = "sata"
    controller   = "IntelAhci"
    port_count   = 1
    bootable     = true
    medium_path  = "debian_vm_disk.vdi"
    size         = 20000
    medium_type  = "normal"
  }

  dvd {
    name       = "Debian ISO"
    medium     = "/home/daniel/Downloads/debian-12.7.0-amd64-netinst.iso"
    device     = "sata"
    port       = 1
    drive_type = "dvddrive"
  }

  options = [
    "--ioapic", "on",
    "--boot1", "dvd",
    "--nictype1", "82540EM"
  ]
}

# Output the IP address of the VM once it's created
output "vm_ip" {
  value = virtualbox_vm.debian_vm.ipv4_address
}
