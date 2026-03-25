# Free WordPress Hosting on Google Cloud (2025 Update)

**Source:** CavemenTech — https://www.youtube.com/watch?v=jqF0jVzM0u8
**Date:** October 2025
**Context:** Modern update to the DevbaseMedia 5-part series (2018-2019). Replaces manual Docker+Nginx+Certbot setup with Bitnami pre-configured VM and one-command SSL.

---

## What Changed Since the Original Series

| Step | DevbaseMedia (2018-2019) | CavemenTech (2025) |
|------|-------------------------|-------------------|
| VM type | f1-micro (deprecated) | **e2-micro** (current free tier) |
| OS | Ubuntu 16.04 minimal | **Bitnami WordPress VM** (pre-configured) |
| WordPress install | Manual Docker Compose | **Pre-installed** via GCP Marketplace |
| Reverse proxy | Manual Nginx install + config | **Apache** (bundled with Bitnami) |
| SSL | Manual Certbot + cron | **`bncert-tool`** (one command, auto-renewal built in) |
| Domain registrar | GoDaddy → Google Domains | **Cloudflare** (Google Domains sold to Squarespace) |
| Swap file | Manual 4GB setup | Not needed (Bitnami optimized) |
| Docker | Manual install + compose | Not used (Bitnami handles stack) |

---

## GCP Always Free Tier (2025)

- **1 non-preemptible e2-micro VM** per month in select US regions
- **30 GB standard persistent disk**
- **1 GB outbound data transfer** from North America
- Limit is by time, not by instance — all e2-micro hours are free until monthly total is reached

---

## Step-by-Step Process

### 1. Deploy WordPress VM from Marketplace

1. Go to **Google Cloud Console** → **Compute Engine**
2. Search for **"WordPress Bitnami"** in the Marketplace
3. Click **Launch**
4. Configure:
   - **Zone:** Must be a free-tier US region (e.g., `us-east1`, `us-west1`, `us-central1`)
   - **Machine type:** Change from e2-small to **e2-micro** (critical — e2-small is NOT free)
   - **Boot disk:** Standard persistent disk, **25 GB** (within 30 GB free limit)
   - **Firewall:** HTTP and HTTPS allowed (default)
5. Click **Deploy**

The deployment provides: external IP, admin URL, username, and password.

### 2. Point Domain via DNS

Using **Cloudflare** (or any DNS provider):

1. Create an **A record**: name = your domain, IPv4 = the GCP external IP
2. Create a second A record for **www** subdomain
3. **Critical for Cloudflare:** Set proxy status to **"DNS only"** (gray cloud) — orange/proxied will break the SSL tool

### 3. Enable HTTPS with One Command

1. In GCP Console, click **SSH** on your VM instance
2. Run:

```bash
sudo /opt/bitnami/bncert-tool
```

3. Follow prompts:
   - Enter domain names (space-separated)
   - Enable HTTP → HTTPS redirection: **Y**
   - Choose www redirect direction
   - Agree to Let's Encrypt terms: **Y**
   - Enter email address

The tool automatically:
- Generates Let's Encrypt SSL certificate
- Installs it in Apache configuration
- Sets up **auto-renewal** (no cron needed)
- Configures redirects

---

## Key Differences for Drupal

This tutorial is WordPress-specific, but the infrastructure pattern applies to Drupal:

- **GCP free tier** works the same for any workload
- **e2-micro** (0.6 GB RAM) is marginal for Drupal — Drupal CMS v2 needs more RAM than WordPress
- **Bitnami has a Drupal image** too (`bitnami/drupal`) but it's Drupal 10, not CMS v2
- For **Drupal CMS v2**, you'd use Docker Compose (Wodby images) instead of Bitnami
- The **DNS and SSL steps** are identical regardless of CMS
- For Eduity's Portainer-based setup, replace Bitnami with a Docker Compose stack deployed via Portainer
