resource "proxmox_vm_qemu" "kmaster" {
  name        = "kmaster"
  description = "Kubernetes master node"
  vmid        = 200
  target_node = "pve"
  scsihw   = "virtio-scsi-pci"

  agent    = 1
  clone    = "ubuntu-cloud-template"
  memory   = 2048

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

  ipconfig0   = "ip=10.10.20.200/24,gw=10.10.20.1"
  nameserver  = "10.10.20.1"
  ciuser     = "ubuntu"
  sshkeys = file(pathexpand("~/.ssh/id_ed25519.pub"))
}