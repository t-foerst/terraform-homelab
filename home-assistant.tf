resource "proxmox_vm_qemu" "home-assistant" {
  name                   = "home-assistant"
  description            = "Home Assistant OS VM"
  vmid                   = 180
  target_node            = "pve2"
  onboot                 = true
  full_clone             = false
  bios                   = "ovmf"
  define_connection_info = false

  boot   = "order=scsi0"
  scsihw = "virtio-scsi-pci"
  agent  = 0

  memory = 4096
  tags   = "homeassistant"

  cpu {
    cores   = 2
    sockets = 1
    type    = "host"
  }

  vga {
    type = "std"
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
    tag    = 50
  }

  disk {
    slot    = "scsi1"
    type    = "disk"
    storage = "local-lvm"
    size    = "32G"
    backup  = true
  }

  # HAOS ISO — muss vorab auf Proxmox unter local:iso/ liegen
  #disk {
  #  slot = "ide0"
  #  type = "cdrom"
  #  iso  = "local:iso/haos_generic-x86-64.iso"
  #}

  lifecycle {
    ignore_changes = [
      disk,
      disks,
      boot,
    ]
  }
}
