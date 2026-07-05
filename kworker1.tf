resource "proxmox_vm_qemu" "kworker1" {
  name        = "kworker1"
  description = "Kubernetes worker node"
  vmid        = 205
  target_node = "pve"
  onboot      = true
  scsihw      = "virtio-scsi-pci"

  agent  = 1
  clone  = "ubuntu-cloud-template"
  memory = 8192
  tags   = "k8s-worker"


  cpu {
    cores   = 2
    sockets = 1
    type    = "host"
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
    tag    = 20
  }

  disk {
    slot    = "scsi0"
    type    = "disk"
    storage = "local-lvm"
    size    = "64G"
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
    ]
  }


  ipconfig0  = "ip=10.10.20.205/24,gw=10.10.20.1"
  nameserver = "10.10.20.1"
  ciuser     = "ubuntu"
  sshkeys    = <<-EOT
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOJgLejiCJaHRWm1ypL3dovLaCTgQUXT2parYFtf8nY0 thorben@fedoraPC
  EOT
}
