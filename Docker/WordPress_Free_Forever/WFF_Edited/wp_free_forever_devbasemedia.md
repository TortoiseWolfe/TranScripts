# WordPress Free Forever — 5-Part Series

**Source:** DevbaseMedia (Chris), YouTube Playlist
**Date cleaned:** 2026-03-25

| Part | Title | URL |
|------|-------|-----|
| 1 | How to Transfer Domains from GoDaddy to Google Domains | https://www.youtube.com/watch?v=nl5RfFaUhXE |
| 2 | Run WordPress for Free Forever with Google Cloud and Docker | https://www.youtube.com/watch?v=5YkkqjwRqN4 |
| 3 | How to Point Your Domain at a Google Cloud Instance | https://www.youtube.com/watch?v=y0VgnNbCneU |
| 4 | Point an NGINX Reverse Proxy to WordPress Running on Docker | https://www.youtube.com/watch?v=SLejN0yC8sM |
| 5 | Set up HTTPS Using Let's Encrypt and NGINX | https://www.youtube.com/watch?v=T7flzYEtMGA |

---

## Part 1: Transfer Domains from GoDaddy to Google Domains

### Why Transfer to Google Domains

- **Pricing:** $17 CAD/year (even lower in USD) vs GoDaddy's higher rates
- **Default features:** Privacy protection built in (free), domain forwarding, email forwarding
- Parked domains can forward email to your main Gmail account

### Transfer Process

**Step 1 — Prepare on GoDaddy:**

- Go to your GoDaddy account and select the domain to transfer
- **Remove private registration** — the transfer will bounce if privacy is enabled
- **Turn off domain lock** — click Edit on the domain lock setting and disable it
- Wait a few minutes for changes to take effect

**Step 2 — Initiate on Google Domains:**

- Go to **domains.google.com** and click "Transfer" instead of searching for a new domain
- Enter the domain name you want to transfer
- Google will confirm the domain is unlocked

**Step 3 — Get authorization code from GoDaddy:**

- On GoDaddy, click "Transfer domain away from GoDaddy"
- Click "Continue with transfer" (skip upsell offers)
- GoDaddy sends a **one-time authorization code** via email

**Step 4 — Complete on Google Domains:**

- Paste the authorization code into Google Domains
- Privacy protection and auto-renew are enabled by default
- **Registration time is preserved** — Google adds a full year to your existing registration date, so you lose nothing
- Proceed to checkout

**Post-transfer:** GoDaddy holds the domain for a few days hoping you change your mind. They send a confirmation email — no action needed.

---

## Part 2: Run WordPress for Free Forever with Google Cloud and Docker

### Google Cloud Platform Free Tier

**GCP** offers an **always-free tier** that includes one **f1-micro VM instance** per month in select regions (us-central1, us-east1, us-west1). The f1-micro has **1 vCPU** and **0.6 GB RAM** — very small, but workable for a low-traffic WordPress blog.

The idea: start free, and if the blog grows, upgrade the VM later. New accounts also get a **$300 credit** for the first year.

### Create a GCP Project and VM Instance

1. Go to **cloud.google.com** and create an account (or sign in)
2. Create a new project (e.g., "WordPress for Free")
3. Navigate to **Compute Engine > VM Instances**
4. Create an instance:
   - **Name:** wordpress
   - **Region:** us-central1
   - **Machine type:** f1-micro (0.6 GB RAM) — shows $4.28/month but is free for your first f1-micro
   - **OS:** Ubuntu 16.04 Minimal (choose minimal to conserve RAM)
   - **Firewall:** Check both "Allow HTTP traffic" and "Allow HTTPS traffic"
5. Click **Create**, then connect via the **SSH** button

### Create a Swap File

The f1-micro has too little RAM for WordPress alone. Create swap space to prevent crashes.

```bash
sudo fallocate -l 4G /swapfile
ls -lh /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

Verify with `top` — you should see 4 GB of swap space.

**Make swap permanent** by editing `/etc/fstab`:

```bash
sudo vi /etc/fstab
```

Add this line at the end:

```
/swapfile none swap sw 0 0
```

Reboot the VM to confirm swap persists.

### Install Docker

```bash
curl -fsSL https://get.docker.com -o install-docker.sh
chmod 755 install-docker.sh
sudo ./install-docker.sh
sudo usermod -aG docker $USER
```

Log out and back in for the group change to take effect. Verify with:

```bash
docker container ls
```

### Install Docker Compose

Download from the Docker Compose documentation (use the command for the current stable release):

```bash
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose version
```

### Install Git and Clone WordPress Compose Repo

```bash
sudo apt install -y git
git clone <forked-wordpress-docker-compose-repo>
cd <repo-directory>
```

The repo contains a **docker-compose.yaml** file configured to run WordPress on port 80.

### Launch WordPress

```bash
docker-compose up -d
docker container ls
```

This downloads **MySQL** and **WordPress** images from Docker Hub and starts both containers pre-configured to communicate with each other.

**Access WordPress** by navigating to the VM's external IP address via HTTP. The first load may take time to initialize. If you get timeouts, restart the VM instance and run:

```bash
docker-compose start
```

Use `docker-compose start` (not `up`) to restart existing containers without recreating them.

---

## Part 3: Point Your Domain at a Google Cloud Instance

### Reserve a Static IP Address

The VM's external IP is **ephemeral** by default — it can change on restart. To fix this:

1. In GCP Console, click the VM instance menu and go to **Network Details**
2. Under **External IP addresses**, change the IP type from **Ephemeral** to **Static**
3. Give it a name (e.g., "wordpress")

The IP address is now permanently reserved for this instance.

### Configure DNS Records

Go to your domain registrar's DNS settings (works with any registrar, not just Google Domains).

**Add an A record:**

| Type | Name | Value |
|------|------|-------|
| A | @ | `<your-static-IP>` |

**Add a CNAME record:**

| Type | Name | Value |
|------|------|-------|
| CNAME | www | `yourdomain.com.` |

The CNAME redirects `www.yourdomain.com` to `yourdomain.com`.

### Verify DNS Propagation

DNS changes may take time. Rather than refreshing the browser repeatedly, use the `dig` command:

```bash
dig yourdomain.com
```

Check that the answer section shows your static IP address. Once propagated, visiting your domain in a browser loads the WordPress site.

---

## Part 4: NGINX Reverse Proxy in Front of WordPress on Docker

### Why Use an NGINX Reverse Proxy

The architecture goal:

```
Internet → NGINX (port 80) → WordPress/Docker (port 8080)
```

**NGINX** acts as a reverse proxy — it accepts all incoming traffic on port 80, then forwards it to WordPress running on port 8080. This is necessary because:

- We need NGINX in front to later add HTTPS (port 443)
- Two services cannot share port 80
- NGINX can serve multiple domains on one machine by routing to different backend ports

### Fix WordPress URL Settings First

Before changing ports, update WordPress to use the actual domain:

1. Go to **wp-admin > Settings > General**
2. Set both **WordPress Address (URL)** and **Site Address (URL)** to `http://yourdomain.com`
3. Save changes

### Change WordPress Port from 80 to 8080

Edit `docker-compose.yaml` — change the port mapping:

```yaml
ports:
  - "8080:80"
```

This exposes port 8080 on the host, directing traffic to port 80 inside the WordPress container.

Recreate the containers:

```bash
docker-compose down
docker-compose up -d
docker ps
```

**Data is preserved** in the `wp-app` and `wp-data` directories even after `docker-compose down`. The containers are recreated and mount on top of existing data.

The website is now temporarily inaccessible because port 8080 is not exposed through the GCP firewall (only 80 and 443 are).

### Install and Configure NGINX

```bash
sudo apt install -y nginx
```

NGINX starts automatically on port 80. Visiting the domain now shows the NGINX welcome page.

**NGINX directory structure:**

```
/etc/nginx/
├── sites-available/    # Configuration files for all sites
├── sites-enabled/      # Symlinks to active site configs
├── conf.d/
└── nginx.conf
```

### Create a Site Configuration

```bash
sudo vi /etc/nginx/sites-available/www.yourdomain.com.conf
```

Configuration contents:

```nginx
server {
    root /var/www/html;
    listen 80;
    listen [::]:80;

    server_name yourdomain.com www.yourdomain.com;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Host $server_name;
    }
}
```

**Key points:**
- **server_name** — matches requests for your domain (with and without www)
- **proxy_pass** — forwards all traffic to localhost port 8080 (WordPress)
- **proxy_set_header** — passes original request headers through to WordPress

### Enable the Site

Create a symbolic link from `sites-available` to `sites-enabled`:

```bash
sudo ln -s /etc/nginx/sites-available/www.yourdomain.com.conf /etc/nginx/sites-enabled/www.yourdomain.com.conf
```

Restart NGINX:

```bash
sudo service nginx restart
```

The domain now loads WordPress through the NGINX proxy. NGINX can proxy multiple domains to different backend ports on the same machine.

---

## Part 5: Set Up HTTPS Using Let's Encrypt and NGINX

### How HTTPS Works with Let's Encrypt

The architecture adds port 443 (HTTPS) to NGINX:

```
Internet → NGINX (port 443, SSL) → WordPress/Docker (port 8080)
         → NGINX (port 80, redirect to 443)
```

**Let's Encrypt** is a free certificate authority. **Certbot** is the application that obtains and manages certificates from Let's Encrypt. Certbot challenges your server to verify you control the domain, then issues certificates.

**Prerequisites:** A real domain name already pointing at your server with NGINX configured (Parts 1-4).

### Install Certbot

```bash
sudo apt install -y software-properties-common
sudo apt update
sudo add-apt-repository ppa:certbot/certbot
sudo apt update
sudo apt install -y python-certbot-nginx
```

### Obtain and Install Certificates

```bash
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com
```

Certbot will:
1. Prompt for an email address (for renewal notices)
2. Ask you to agree to terms of service
3. **Challenge your server** to verify domain ownership
4. Ask whether to **redirect HTTP to HTTPS** (choose redirect)
5. Automatically modify your NGINX config file

After running, the NGINX config at `/etc/nginx/sites-available/www.yourdomain.com.conf` is updated with SSL certificate paths and a redirect from port 80 to 443.

Restart NGINX:

```bash
sudo service nginx restart
```

The site now shows the padlock icon and the certificate is issued by Let's Encrypt (expires in ~90 days).

### Fix WordPress for HTTPS (SSL Reverse Proxy)

WordPress may serve mixed content (some resources via HTTP). Edit `wp-config.php`:

```bash
sudo vi wordpress-docker-compose/wp-app/wp-config.php
```

Add this block before `/* That's all, stop editing! */`:

```php
/* SSL reverse proxy */
if ($_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https') {
    $_SERVER['HTTPS'] = 'on';
}
```

This tells WordPress to treat the connection as HTTPS when the `X-Forwarded-Proto` header indicates it.

### Add X-Forwarded-Proto Header to NGINX

Edit the NGINX site config and add this header to the location block:

```nginx
proxy_set_header X-Forwarded-Proto $scheme;
```

The full set of proxy headers should be:

```nginx
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Host $server_name;
proxy_set_header X-Forwarded-Proto $scheme;
```

Restart NGINX and WordPress:

```bash
sudo service nginx restart
cd wordpress-docker-compose
docker-compose stop
docker-compose start
```

Also update **wp-admin > Settings > General** to use `https://` for both WordPress URL and Site Address URL.

### Set Up Auto-Renewal with Cron

Let's Encrypt certificates expire every 90 days. Certbot only renews if the certificate is within 30 days of expiry.

Test renewal (will report "not yet due"):

```bash
sudo certbot renew
```

Add a daily cron job to attempt renewal:

```bash
sudo crontab -e
```

Add this line:

```cron
45 2 * * * certbot renew >> /tmp/renew.log 2>&1
```

This runs `certbot renew` every day at **2:45 AM** and logs output to `/tmp/renew.log`. Since the crontab belongs to root, no `sudo` is needed in the command.
