resource "proxmox_lxc" "minio" {
  target_node  = "pve"
  hostname     = "minio"
  description  = <<-EOT
  MinIO LXC - High-Performance Object Storage (managed by Terraform)

  Zugriff:
  - API:     10.10.20.213:9000
  - Console: 10.10.20.213:9001

  Wichtige Pfade:
  - Data:    /minio/data
  - Config:  /minio/.minio.sys
  - Logs:    journalctl -u minio
  EOT

  vmid         = 213
  ostemplate   = "local:vztmpl/debian-13-standard_13.1-2_amd64.tar.zst"
  unprivileged = true
  start        = true
  onboot       = true

  cores  = 2
  memory = 2048
  swap   = 512

  rootfs {
    storage = "local-lvm"
    size    = "5G"
  }

  mountpoint {
    key     = "0"
    slot    = 0
    storage = "zfsStorage"
    mp      = "/minio/data"
    size    = "4T"
    backup  = true
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
      ostemplate,
      rootfs,
      ssh_public_keys,
      mountpoint,
      network,
    ]
  }
}
