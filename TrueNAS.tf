resource "proxmox_vm_qemu" "truenas" {
  name        = "truenas"
  description = "TrueNAS SCALE NAS/Storage VM"
  vmid        = 220
  target_node = "pve"
  onboot      = true

  # Kein clone — Boot von ISO
  boot   = "order=ide0;scsi0"
  scsihw = "virtio-scsi-pci"
  agent  = 0

  memory = 8192

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
    tag    = 20
  }

  # OS-Disk (TrueNAS installiert sich hier)
  disk {
    slot    = "scsi0"
    type    = "disk"
    storage = "local-lvm"
    size    = "16G"
    backup  = true
  }

  # Boot-ISO
  disk {
    slot = "ide0"
    type = "cdrom"
    iso  = "local:iso/TrueNAS-SCALE-25.10.3.1.iso"
  }

  lifecycle {
    ignore_changes = [
      disk,
      boot,
    ]
  }
}
