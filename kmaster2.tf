resource "proxmox_vm_qemu" "kmaster2" {
  name        = "kmaster2"
  description = "Kubernetes master node"
  vmid        = 201
  target_node = "pve"
  onboot      = true
  scsihw   = "virtio-scsi-pci"

  agent    = 1
  clone    = "ubuntu-cloud-template"
  memory   = 4096

  cpu {
    cores   = 2
    sockets = 1
    type    = "host"
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
    tag   = 20
  }

  disk {
    slot    = "scsi0"
    type    = "disk"
    storage = "local-lvm"
    size    = "32G"
    backup  = true
  }

  disk {
    slot    = "ide2"
    type    = "cloudinit"
    storage = "local-lvm"
  }
  
  serial {
    id   = 0
    type = "socket"
  }

  vga {
    type = "serial0"
  }

  lifecycle {
    ignore_changes = [
      disk,
      tags,
    ]
  }


  ipconfig0   = "ip=10.10.20.201/24,gw=10.10.20.1"
  nameserver  = "10.10.20.1"
  ciuser     = "ubuntu"
  sshkeys = <<-EOT
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOJgLejiCJaHRWm1ypL3dovLaCTgQUXT2parYFtf8nY0 thorben@fedoraPC
  EOT
}