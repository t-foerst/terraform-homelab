resource "hcloud_ssh_key" "thorben" {
  name       = "thorben-fedoraPC"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOJgLejiCJaHRWm1ypL3dovLaCTgQUXT2parYFtf8nY0 thorben@fedoraPC"
}

resource "hcloud_firewall" "netbird" {
  name = "netbird-control-plane"

  # SSH
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  # HTTPS (Management UI + API + Let's Encrypt)
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "443"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  # HTTP (Let's Encrypt ACME challenge)
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "80"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  # Signal Service (gRPC/QUIC)
  rule {
    direction  = "in"
    protocol   = "udp"
    port       = "10000"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  # STUN/TURN (WireGuard hole punching)
  rule {
    direction  = "in"
    protocol   = "udp"
    port       = "3478"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
}

resource "hcloud_server" "netbird" {
  name        = "netbird-control-plane"
  server_type = "cx23"
  image       = "debian-13"
  location    = "fsn1" # Falkenstein, Deutschland
  ssh_keys    = [hcloud_ssh_key.thorben.id]

  firewall_ids = [hcloud_firewall.netbird.id]

  labels = {
    role = "netbird-control-plane"
  }
}

output "netbird_hetzner_ip" {
  description = "Öffentliche IPv4 des NetBird Control Plane Servers"
  value       = hcloud_server.netbird.ipv4_address
}
