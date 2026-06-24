resource "proxmox_vm_qemu" "truenas" {
  name                   = "truenas"
  description            = "TrueNAS SCALE NAS/Storage VM"
  vmid                   = 220
  target_node            = "pve"
  onboot                 = true
  define_connection_info = false

  # Kein clone — Boot von ISO
  full_clone = false
  boot       = "order=scsi0"
  scsihw     = "virtio-scsi-pci"
  agent      = 0

  memory = 8192
  tags   = "storage"

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

  disks {
    ide {
      ide0 {
        cdrom {
          iso = "local:iso/TrueNAS-SCALE-25.10.3.1.iso"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          backup  = true
          size    = "16G"
          storage = "local-lvm"
          format  = "raw"
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [

    ]
  }
}
