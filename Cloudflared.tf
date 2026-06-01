resource "proxmox_lxc" "cloudflared" {
  target_node = "pve2"
  hostname    = "cloudflared"
  description = <<-EOT
  Cloudflare Tunnel (cloudflared) LXC (managed by Terraform)

  Baut einen ausgehenden Tunnel zu Cloudflare auf.
  Kein eingehender Port erforderlich.

  Wichtige Pfade:
  - Config:   /etc/cloudflared/config.yml
  - Token:    /etc/cloudflared/.cloudflared/cert.pem
  - Logs:     journalctl -u cloudflared
  EOT

  vmid         = 215
  ostemplate   = "local:vztmpl/debian-13-standard_13.1-2_amd64.tar.zst"
  unprivileged = true
  start        = true
  onboot       = true

  cores  = 1
  memory = 256
  swap   = 128

  rootfs {
    storage = "local-lvm"
    size    = "4G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "10.10.40.215/24"
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
