resource "proxmox_lxc" "gitea" {
  target_node  = "pve"
  hostname     = "gitea"
  description = <<-EOT
  Gitea LXC (managed by Terraform)

  Update Gitea:
  1. systemctl stop gitea
  2. wget neue Binary nach /tmp
  3. optional: gpg --verify
  4. mv Binary nach /usr/local/bin/gitea
  5. systemctl start gitea
  6. gitea --version prüfen

  Daten:
  - Config: /etc/gitea/app.ini
  - Data:   /var/lib/gitea
  - Binary: /usr/local/bin/gitea
  EOT
  vmid = 210
  ostemplate   = "local:vztmpl/debian-13-standard_13.1-2_amd64.tar.zst"
  unprivileged = true
  start        = true

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
    storage = "zfsStorage"
    mp      = "/var/lib/gitea"
    size    = "500G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "10.10.20.210/24"
    gw = "10.10.20.1"
    tag   = 20
  }
  ssh_public_keys = file(pathexpand("~/.ssh/id_ed25519.pub"))
}