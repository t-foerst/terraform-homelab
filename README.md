# terraform-homelab

Infrastructure-as-Code for my homelab: a self-hosted Kubernetes (k3s) cluster on Proxmox VE, plus supporting services for storage, smart home, and secure remote access — all provisioned and version-controlled with Terraform.

## What's in here

- **Kubernetes cluster** — HA k3s control plane (multiple master nodes) and worker nodes, provisioned as Proxmox VMs from a cloud-init template.
- **NAS / storage** — [TrueNAS SCALE](https://www.truenas.com/truenas-scale/) VM for bulk storage.
- **Smart home** — [Home Assistant OS](https://www.home-assistant.io/) VM.
- **Remote access** — [NetBird](https://netbird.io/) (WireGuard-based mesh VPN) subnet router for secure access into the homelab without exposing services to the internet.
- **Database** — PostgreSQL LXC container for application data.

Compute lives on Proxmox VE across multiple nodes; one resource ([`netbird-router.tf`](netbird-router.tf)) connects the homelab to a NetBird overlay network rather than exposing ports directly.

## Tech stack

| Layer | Tool |
|---|---|
| IaC | Terraform |
| Hypervisor | Proxmox VE |
| Container orchestration | k3s (Kubernetes) |
| Cloud provider (optional) | Hetzner Cloud |
| Remote access | NetBird (WireGuard) |

## Repository structure

```
versions.tf              # Terraform + provider version constraints
providers.tf             # Provider configuration
variables.tf             # Input variable declarations
kmaster*.tf, kworker*.tf  # k3s cluster nodes (Proxmox VMs)
k3s-database.tf           # PostgreSQL LXC for cluster workloads
truenas.tf                # TrueNAS SCALE NAS VM
home-assistant.tf         # Home Assistant OS VM
netbird-router.tf          # NetBird subnet router LXC
terraform.tfvars.example  # Template for required secrets/credentials
```

Each resource lives in its own file named after the service it provisions — there's no separate "resources" doc to keep in sync; the `.tf` files themselves are the source of truth.

## Prerequisites

- Proxmox VE with API token access
- VM template with cloud-init enabled (for k3s nodes)
- LXC template for Debian-based containers
- Terraform >= 0.13.0

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars   # fill in your credentials
terraform init
terraform plan
terraform apply
```

`terraform.tfvars` holds real credentials and is gitignored — never commit it.
