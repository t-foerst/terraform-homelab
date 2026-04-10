resource "proxmox_lxc" "postgres" {
  target_node  = "pve"
  hostname     = "postgres"
  description  = <<-EOT
  PostgreSQL LXC (managed by Terraform)

  Wichtige Pfade:
  - Config: /etc/postgresql/*/main/postgresql.conf
  - Data:   /var/lib/postgresql
  - Logs:   /var/log/postgresql
  EOT
  vmid         = 211
  ostemplate   = "local:vztmpl/debian-13-standard_13.1-2_amd64.tar.zst"
  unprivileged = true
  start        = true
  onboot       = true

  cores  = 2
  memory = 2048
  swap   = 512

  rootfs {
    storage = "local-lvm"
    size    = "8G"
  }

  mountpoint {
    key     = "0"
    slot    = 0
    storage = "local-lvm"
    mp      = "/var/lib/postgresql"
    size    = "50G"
    backup  = true
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "10.10.20.211/24"
    gw     = "10.10.20.1"
    tag    = 20
  }

  lifecycle {
    ignore_changes = [
      //ostemplate,
      //rootfs,
      //ssh_public_keys,
      //mountpoint,
      //network,
    ]
  }

  ssh_public_keys = <<-EOT
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOJgLejiCJaHRWm1ypL3dovLaCTgQUXT2parYFtf8nY0 thorben@fedoraPC
  EOT
}