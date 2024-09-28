# Define the VirtualBox provider
provider "virtualbox" {
  # Optional, specify the path to VBoxManage if not in PATH
  vboxmanage_path = "/usr/bin/VBoxManage"
}

terraform {
  required_providers {
    virtualbox = {
      source  = "local/virtualbox"
      version = "6.1.50"  # Specify the version you installed
    }
  }
}

provider "virtualbox" {
  # Optional configurations
}


# Define a VirtualBox VM resource
resource "virtualbox_vm" "debian_vm" {
  name      = "Debian_VM"
  ostype    = "Debian_64"   # Define the OS type
  cpus      = 2             # Number of CPUs
  memory    = 2048          # Memory size in MB

  # VM settings
  image = "~/Downloads/debian-12.7.0-amd64-netinst.iso"  # Path to your Debian ISO file
  vrde {
    enabled = true  # Enable Remote Desktop Protocol (RDP)
    port    = 5000  # RDP port
  }

  network_adapter {
    type           = "bridged"  # Network type, can be "bridged", "hostonly", or "nat"
    host_interface = "en0"      # Name of the host interface, adjust based on your setup
  }

  storage {
    name         = "sata"
    controller   = "IntelAhci"
    port_count   = 1
    bootable     = true
    medium_path  = "debian_vm_disk.vdi"  # Virtual disk file
    size         = 20000                 # Disk size in MB
    medium_type  = "normal"              # Disk type: normal, immutable, writethrough, etc.
  }
  
  # Attach the ISO for installation
  dvd {
    name       = "Debian ISO"
    medium     = "file:~/Downloads/debian-12.7.0-amd64-netinst.iso"  # Replace with the path to your Debian ISO
    device     = "sata"
    port       = 1
    drive_type = "dvddrive"
  }

  # Additional options
  options = [
    "--ioapic", "on",
    "--boot1", "dvd",
    "--nictype1", "82540EM"
  ]
}

# Output the IP address of the VM once it’s created
output "vm_ip" {
  value = virtualbox_vm.debian_vm.ipv4_address
}
