resource "proxmox_lxc" "netbird_router" {
  target_node = "pve2"
  hostname    = "netbird-router"
  description = <<-EOT
  NetBird Subnet Router LXC (managed by Terraform)

  Routet Traffic aus dem NetBird-Netz in die internen Subnetze.
  Benötigt privilegierten Modus für WireGuard-Kernelzugriff.

  Wichtige Pfade:
  - Config:  /etc/netbird/config.json
  - Logs:    journalctl -u netbird
  EOT

  vmid         = 217
  ostemplate   = "local:vztmpl/debian-13-standard_13.1-2_amd64.tar.zst"
  unprivileged = true
  start        = true
  onboot       = true

  cores  = 1
  memory = 256
  swap   = 128

  features {
    nesting = true
  }

  rootfs {
    storage = "local-lvm"
    size    = "4G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "10.10.40.217/24"
    gw     = "10.10.40.1"
    tag    = 40
  }

  ssh_public_keys = <<-EOT
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOJgLejiCJaHRWm1ypL3dovLaCTgQUXT2parYFtf8nY0 thorben@fedoraPC
  EOT

  lifecycle {
    ignore_changes = [
      ostemplate,
      rootfs,
      ssh_public_keys,
      network,
    ]
  }
}
