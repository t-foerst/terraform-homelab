resource "proxmox_vm_qemu" "test" {
  name        = "test"
  description = "This is a test VM created by Terraform"
  vmid        = 200
  target_node = "pve"

  agent    = 0
  clone    = "ubuntu-cloud"
  os_type  = "cloud-init"
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

  ipconfig0   = "ip=10.10.20.200/24,gw=10.10.20.1"
  nameserver  = "10.10.20.1"
  ciuser      = "user"
  sshkeys = file("~/.ssh/id_ed25519.pub")
}