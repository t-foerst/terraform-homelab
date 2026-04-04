resource "proxmox_lxc" "nfs" {
  target_node  = "pve"
  hostname     = "nfs"
  description  = <<-EOT
   NFS LXC for k3s shared storage (managed by Terraform)

   - Export Pfad: /srv/exports/k3s
   - Lokaler Pfad: /zfsStorage/k3s

    Wichtige Pfade:
    - Config: /etc/exports
    - Logs:   journalctl -u nfs-kernel-server
  EOT

  vmid         = 213
  ostemplate   = "local:vztmpl/debian-13-standard_13.1-2_amd64.tar.zst"
  unprivileged = false
  start        = true
  onboot       = true

  cores  = 2
  memory = 1024
  swap   = 512

  rootfs {
    storage = "local-lvm"
    size    = "8G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "10.10.20.213/24"
    gw     = "10.10.20.1"
    tag    = 20
  }

  ssh_public_keys = <<-EOT
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOJgLejiCJaHRWm1ypL3dovLaCTgQUXT2parYFtf8nY0 thorben@fedoraPC
  EOT

  lifecycle {
    ignore_changes = [
    ]
  }
}