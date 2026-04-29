# terraform-homelab

Terraform configuration for a production-like homelab Kubernetes cluster running on Proxmox VE. Provisions a full HA k8s cluster with supporting infrastructure including load balancers, object storage, and a relational database — all as code.

## Resources

| Resource | Type | VMID | CPU | RAM | Disk |
|---|---|---|---|---|---|
| kmaster | VM (Ubuntu Cloud) | 200 | 2 | 2 GB | 32 GB |
| kmaster2 | VM (Ubuntu Cloud) | 201 | 2 | 2 GB | 32 GB |
| kworker1 | VM (Ubuntu Cloud) | 205 | 2 | 2 GB | 32 GB |
| kworker2 | VM (Ubuntu Cloud) | 206 | 2 | 2 GB | 32 GB |
| kworker3 | VM (Ubuntu Cloud) | 207 | 2 | 4 GB | 32 GB + 4 TB (ZFS) |
| HAProxy Internal | LXC (Debian 13) | 212 | 1 | 512 MB | 8 GB |
| HAProxy External | LXC (Debian 13) | 214 | 1 | 512 MB | 8 GB |
| PostgreSQL | LXC (Debian 13) | 211 | 2 | 2 GB | 8 GB + 50 GB (ZFS) |
| MinIO | LXC (Debian 13) | 213 | 2 | 2 GB | 5 GB + 4 TB (ZFS) |

## Prerequisites

- Proxmox VE with API token access
- VM template: `ubuntu-cloud-template` (cloud-init enabled)
- LXC template: `debian-13-standard_13.1-2_amd64.tar.zst`
- Storage pools: `local-lvm` (OS disks), `zfsStorage` (large data volumes)
- Terraform >= 0.13.0

## Usage

```bash
# Initialize providers
terraform init

# Preview changes
terraform plan

# Apply
terraform apply
```

### terraform.tfvars

```hcl
proxmox_api_url          = "https://<proxmox-host>:8006/api2/json"
proxmox_api_token_id     = "<user>@pam!<token-name>"
proxmox_api_token_secret = "<token-secret>"
```

## Provider

Uses [`telmate/proxmox`](https://registry.terraform.io/providers/Telmate/proxmox/latest) v3.0.2-rc04.
