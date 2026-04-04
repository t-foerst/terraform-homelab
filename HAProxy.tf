resource "proxmox_lxc" "haproxy" {
  target_node  = "pve"
  hostname     = "haproxy"
  description  = <<-EOT
  HAProxy LXC for k3s API load balancing (managed by Terraform)

  Frontend:
  - 10.10.20.212:6443 -> k3s server nodes

  Backends:
  - 10.10.20.200:6443 (kmaster)
  - 10.10.20.201:6443 (kmaster2)

  Wichtige Pfade:
  - Config: /etc/haproxy/haproxy.cfg
  - Logs:   journalctl -u haproxy
  EOT

  vmid         = 212
  ostemplate   = "local:vztmpl/debian-13-standard_13.1-2_amd64.tar.zst"
  unprivileged = true
  start        = true
  onboot       = true

  cores  = 1
  memory = 512
  swap   = 256

  rootfs {
    storage = "local-lvm"
    size    = "4G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "10.10.20.212/24"
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
      network,
    ]
  }
}