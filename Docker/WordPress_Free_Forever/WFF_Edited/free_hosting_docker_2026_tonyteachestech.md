# Free Website Hosting with Docker (2026 Update)

**Source:** Tony Teaches Tech, YouTube
- Video 1: [How to Host a FREE Website on Google Cloud (Step-by-Step)](https://www.youtube.com/watch?v=XNf3d1oi2pM) (Oct 2025)
- Video 2: [Self-Host the Right Way (Docker + Cloudflare Tunnels)](https://www.youtube.com/watch?v=iPlUO9xu36c) (Jan 2026)

---

## Part 1: Free Website on Google Cloud with Caddy + Docker

Host a website on **GCP's Always Free tier** using Docker and Caddy for automatic HTTPS.

### GCP Always Free Tier Specifications

- **Machine type:** e2-micro (2 vCPUs, 1 GB memory)
- **Regions:** US Central 1 (Iowa), US West 1 (Oregon), US East 1 (South Carolina)
- **Storage:** 30 GB standard persistent disk
- **Outbound bandwidth:** 1 GB/month (the network tier selector does NOT increase this for free VMs)
- **Provisioning model:** Standard (not Spot/preemptable)
- Credit card required to sign up, but stays free within limits

### Create the VM Instance

1. Go to **cloud.google.com** > Console > Compute Engine > Overview > Create Instance
2. Enable the **Compute Engine API** if first time
3. Configure:
   - **Region:** US Central 1 (Iowa) or other free-tier region
   - **Machine type:** E2 > e2-micro
   - **OS:** Ubuntu 24.04 LTS, x86/64 (not ARM)
   - **Boot disk:** 30 GB, standard persistent disk
4. **Data protection:** Disable backups (avoids fees)
5. **Networking:** Enable HTTP and HTTPS traffic; keep Premium network tier
6. **Observability:** Disable ops agent (avoids fees)
7. **Security:** No service account
8. **Advanced > Provisioning model:** Standard
9. Click **Create**

### Connect via SSH

- Click **SSH > Open in browser window** from the GCP console
- Authorize through your Google account (one-time)

### Install Docker

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

Add your user to the Docker group (avoids needing `sudo` for every command):

```bash
sudo usermod -aG docker $USER
```

Exit and reconnect SSH for group changes to take effect:

```bash
exit
```

### Set Up Caddy with Docker Compose

Create a project directory:

```bash
mkdir site && cd site
```

Create `docker-compose.yml`:

```yaml
services:
  caddy:
    image: caddy
    container_name: caddy_demo
    ports:
      - "80:80"
      - "443:443"
```

Start the container:

```bash
docker compose up -d
docker compose ps
```

Visit `http://<EXTERNAL_IP>` to see the default Caddy landing page. Use `http://` explicitly since HTTPS is not configured yet.

### Configure DNS

At your domain registrar, create DNS records:

- **A Record:** `yourdomain.com` -> your VM's external IP
- **A Record (optional):** `www.yourdomain.com` -> your VM's external IP

### Create the Caddyfile

In your `site/` directory, create a file called `Caddyfile`:

```
yourdomain.com {
    root * /srv
    file_server
}
```

This tells Caddy to serve files from `/srv` inside the container. Caddy **automatically provisions SSL/HTTPS** via Let's Encrypt.

### Create Site Content

```bash
mkdir public
nano public/index.html
```

Add your HTML content to `index.html`.

### Add Volumes to Docker Compose

Update `docker-compose.yml` to mount local files into the container:

```yaml
services:
  caddy:
    image: caddy
    container_name: caddy_demo
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./public:/srv
      - ./Caddyfile:/etc/caddy/Caddyfile
```

Restart to apply:

```bash
docker compose down
docker compose up -d
```

Visit `https://yourdomain.com` -- Caddy handles SSL automatically.

### Bandwidth Limitations and Workaround

- **Free tier limit:** 1 GB outbound/month
- A 2 MB website = ~500 page views before hitting the limit
- Overage cost: ~$0.12/GB
- **Workaround:** Add **Cloudflare CDN** (free tier) in front -- caches static content, effectively 10x your page view capacity (~5,000 pages/month)

---

## Part 2: Self-Hosting with Docker + Cloudflare Tunnels

Host a WordPress site on any server (cloud VPS or home hardware) with **Cloudflare Tunnels** -- no port forwarding, free SSL, free CDN, no public IP exposure.

### Provision a VPS

Using DigitalOcean as the example ($6/month, or free with credits):

1. **Create > Droplets**
2. **Region:** Closest to you
3. **OS:** Ubuntu 24.04 LTS
4. **Plan:** Basic, $6/month
5. **Authentication:** SSH key (required for cloud-init script)
6. **Advanced options:**
   - Enable **IPv6**
   - Paste the **cloud-init script** (automates server hardening: disables root login, locks down SSH, configures firewall)
   - Change the username in the script to your own
7. **Hostname:** Something short (e.g., `wp`)
8. Click **Create Droplet**

### Connect via SSH

```bash
ssh yourusername@YOUR_SERVER_IP
```

First connection: type `yes` to trust the host. If you get "permission denied," wait 1-2 minutes for cloud-init to finish.

Verify cloud-init completed by checking the log -- look for "Your server is configured and ready" at the end.

### Install Docker

Remove any pre-existing Docker installations (important for home servers):

```bash
sudo apt-get remove docker docker-engine docker.io containerd runc
```

Install Docker and Docker Compose:

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

Add user to Docker group and reboot:

```bash
sudo usermod -aG docker $USER
sudo reboot
```

Reconnect via SSH after reboot.

### Deploy WordPress + MariaDB

Create a project directory:

```bash
mkdir mywebsite && cd mywebsite
```

Create `.env` file with database credentials:

```bash
nano .env
```

```env
WORDPRESS_DB_USER=your_db_user
WORDPRESS_DB_PASSWORD=your_secure_password
WORDPRESS_DB_NAME=your_db_name
MYSQL_ROOT_PASSWORD=your_root_password
```

**Change these values to something secure.** Never use defaults in production.

Create `docker-compose.yml`:

```yaml
services:
  wordpress:
    image: wordpress:latest
    ports:
      - "8000:80"
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: ${WORDPRESS_DB_USER}
      WORDPRESS_DB_PASSWORD: ${WORDPRESS_DB_PASSWORD}
      WORDPRESS_DB_NAME: ${WORDPRESS_DB_NAME}
    volumes:
      - wordpress_data:/var/www/html

  db:
    image: mariadb:latest
    environment:
      MYSQL_DATABASE: ${WORDPRESS_DB_NAME}
      MYSQL_USER: ${WORDPRESS_DB_USER}
      MYSQL_PASSWORD: ${WORDPRESS_DB_PASSWORD}
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
    volumes:
      - db_data:/var/lib/mysql

volumes:
  wordpress_data:
  db_data:
```

Start the containers:

```bash
docker compose up -d
docker compose ps
```

Verify WordPress loads at `http://YOUR_SERVER_IP:8000`. **Do not complete WordPress installation yet** -- it will bind to the IP address instead of your domain.

### Set Up Cloudflare Tunnel

Cloudflare Tunnels provide:
- **Free SSL certificate** (no Certbot/Let's Encrypt needed)
- **Free CDN** and bot protection
- **No port forwarding** -- works from any device (cloud VPS, home server, Raspberry Pi)
- **No public IP exposure** -- the tunnel connects outbound from your server

#### Steps:

1. Add your domain to **Cloudflare** (free account)
2. Go to **Zero Trust > Networks > Tunnels > Manage Tunnels**
3. Click **Add a tunnel** > name it (e.g., "WordPress VPS") > Save
4. Select **Debian** (Ubuntu is Debian-based)
5. Copy and run the **install command** on your server to install `cloudflared`
6. Copy and run the **service install command** to set up the tunnel as a background service
7. Verify the connector shows **Connected** in the Cloudflare dashboard
8. Click **Next** > Configure the public hostname:
   - **Domain:** yourdomain.com
   - **Path:** (leave empty)
   - **Service type:** HTTP
   - **URL:** `localhost:8000`
9. Click **Complete setup**

**How it works:** When someone visits `yourdomain.com`, Cloudflare routes traffic through the tunnel to `localhost:8000` on your server. HTTPS is handled entirely by Cloudflare -- no certificates to manage on your server.

### Update PHP Version via Docker

Check current versions in WordPress: **Tools > Site Health > Info > Server**

To change PHP version, update the image tag in `docker-compose.yml`:

```yaml
# Instead of:
image: wordpress:latest
# Use a specific version:
image: wordpress:6.9-php8.4
```

Apply the change:

```bash
docker compose up -d
```

Docker pulls the new image automatically. Much easier than updating system packages.

### Lock Down the Firewall

Since all web traffic flows through the Cloudflare tunnel, close the temporary port:

```bash
sudo ufw delete allow 8000/tcp
sudo ufw status
```

Final firewall state: **only port 22 (SSH) open**. The website still loads through the Cloudflare tunnel with no ports exposed.

### Architecture Summary

```
User -> Cloudflare CDN/SSL -> Cloudflare Tunnel -> localhost:8000 -> WordPress container
                                                                   -> MariaDB container
```

- No ports open except SSH
- SSL termination at Cloudflare (free)
- CDN caching at Cloudflare (free)
- No public IP exposure for web traffic
- Works identically for cloud VPS or home hardware (Raspberry Pi, etc.)
