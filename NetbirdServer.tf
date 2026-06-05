resource "proxmox_lxc" "netbird" {
  target_node = "pve2"
  hostname    = "netbird"
  description = <<-EOT
  NetBird Koordinationsserver LXC (managed by Terraform)

  Self-hosted NetBird Management + Signal Server.

  Ports:
  - 80/443:  HTTPS (Management UI + API, Let's Encrypt)
  - 10000:   Signal Service (gRPC/QUIC)
  - 33073:   Management Service (gRPC)

  Wichtige Pfade:
  - Config:   /etc/netbird/management.json
  - Docker:   /opt/netbird/docker-compose.yml
  - Logs:     journalctl -u docker / docker compose logs
  EOT

  vmid         = 216
  ostemplate   = "local:vztmpl/debian-13-standard_13.1-2_amd64.tar.zst"
  unprivileged = true
  start        = true
  onboot       = true

  cores  = 2
  memory = 1024
  swap   = 512

  features {
    nesting = true
  }

  rootfs {
    storage = "local-lvm"
    size    = "8G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "10.10.40.216/24"
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
