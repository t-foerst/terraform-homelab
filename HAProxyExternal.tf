resource "proxmox_lxc" "haproxyexternal" {
  target_node  = "pve"
  hostname     = "haproxyexternal"
  description  = <<-EOT
  HAProxy LXC for k3s external Ingress load balancing (managed by Terraform) + Öffentlicher IP updater mir Dnsexit (meinvpn.work.gd)

  Frontend:
  - 10.10.40.214:80 -> k3s server nodes

  Backends:
  - 10.10.20.200:32080 (kmaster)
  - 10.10.20.201:32080 (kmaster2)

    Frontend:
  - 10.10.40.214:443 -> k3s server nodes

  Backends:
  - 10.10.20.200:32443 (kmaster)
  - 10.10.20.201:32443 (kmaster2)

  Wichtige Pfade:
  - Config: /etc/haproxy/haproxy.cfg
  - Logs:   journalctl -u haproxy
  EOT

  vmid         = 214
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
    ip     = "10.10.40.214/24"
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
    ]
  }
}