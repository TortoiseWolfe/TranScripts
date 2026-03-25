# Drupal CMS v2 Free Forever — Twitch Stream Script

**Channel:** TurtleWolfe on Twitch
**Format:** Live coding / tutorial stream (~45-60 min)
**Prerequisite knowledge:** None (beginner-friendly, but Docker experience helps)
**Real-world context:** Building the Eduity LLC website as a live example

---

## Cold Open (~2 min)

> You've probably seen those "WordPress Free Forever" tutorials — set up a free Google Cloud VM, install WordPress, done. I curated a whole playlist of those.
>
> But what if you need something more powerful? What if your client needs content templates, a visual page builder, AI-powered content generation, and enterprise-grade content management?
>
> Today we're doing **Drupal CMS v2 — Free Forever**. Same concept, different CMS. And I'm building this live for a real client — Eduity LLC out of Chattanooga. They need a 7-page site with a blog and social media feeds.
>
> Let's see if we can get Drupal CMS v2 running, themed, and publicly accessible — for zero dollars a month.

---

## Part 1: Why Not Just Use WordPress? (~5 min)

### The honest comparison

| Feature | WordPress | Drupal CMS v2 |
|---------|-----------|---------------|
| Page builder | Gutenberg (basic) | **Canvas** (drag-and-drop, SDC components, AI generation) |
| Theming | PHP templates | **Tailwind CSS + Single Directory Components** |
| Content modeling | Custom Post Types (limited) | **Structured content types + field mapping** |
| Automation | Plugin-dependent | **ECA** (Event-Condition-Action, built-in) |
| AI integration | Plugins ($$$) | **Drupal AI module** (free, supports OpenAI/Anthropic) |
| Config management | wp-config.php | **YAML config sync** (git-friendly, deployable) |
| Recipes | None | **Recipe system** (one-click feature bundles) |
| RAM needed | ~350 MB | ~600+ MB |
| Free tier viable? | Yes (e2-micro fine) | **Tight** — needs swap or Cloudflare Tunnel approach |

> The trade-off: Drupal gives you way more power, but it's heavier. That changes our infrastructure strategy.

---

## Part 2: Infrastructure — Two Paths (~10 min)

### Path A: GCP Free Tier (tight but works)

Same e2-micro as the WordPress tutorials, but we need a swap file because Drupal + MariaDB + PHP-FPM needs more than 1 GB RAM.

```bash
# GCP Always Free tier specs (2025-2026):
# - e2-micro: 2 vCPU, 1 GB RAM
# - 30 GB standard persistent disk
# - 1 GB outbound bandwidth/month
# - US regions only: us-central1, us-west1, us-east1
```

**Create the VM** (same as Tony Teaches Tech GCP tutorial):

1. Google Cloud Console → Compute Engine → Create Instance
2. Region: **us-central1** (Iowa)
3. Machine type: **e2-micro** (not e2-small!)
4. OS: **Ubuntu 24.04 LTS** (x86/64)
5. Boot disk: **30 GB standard persistent disk**
6. Enable HTTP + HTTPS firewall rules
7. Disable backups, ops agent, service account
8. Provisioning: **Standard** (not Spot)

**Add swap** (Drupal needs this on e2-micro):

```bash
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

### Path B: Any Server + Cloudflare Tunnels (recommended)

This is the better approach for Drupal. Works on:
- A $6/month DigitalOcean/Hetzner VPS (2 GB RAM, comfortable)
- Oracle Cloud free tier (4 CPU + 24 GB ARM — very generous)
- A Raspberry Pi at home
- Your existing development machine

> I'm going with Path B because my client Eduity already has a server with Portainer. But the Docker Compose file is identical either way.

---

## Part 3: Docker + Docker Compose Setup (~5 min)

### Install Docker

```bash
# Works on any Ubuntu/Debian system
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
# Log out and back in for group change to take effect
```

### Project structure

```bash
mkdir ~/drupal-site && cd ~/drupal-site
```

We need two files: `.env` for secrets and `compose.yml` for the stack.

### Environment file

```bash
nano .env
```

```env
# .env — DO NOT commit this file
PROJECT_NAME=eduity
PROJECT_BASE_URL=eduity.example.com
PROJECT_PORT=8080

DB_NAME=drupal
DB_USER=drupal
DB_PASSWORD=change-me-to-something-secure
DB_ROOT_PASSWORD=change-me-root-secure
DB_HOST=mariadb
DB_DRIVER=mysql

MARIADB_TAG=11
PHP_TAG=8.3-dev-4.x
NGINX_TAG=1.27
NGINX_VHOST_PRESET=drupal11
```

---

## Part 4: Docker Compose Stack (~15 min)

### The compose.yml walkthrough

```bash
nano compose.yml
```

```yaml
services:
  mariadb:
    image: wodby/mariadb:${MARIADB_TAG}
    container_name: "${PROJECT_NAME}_mariadb"
    stop_grace_period: 30s
    environment:
      MYSQL_ROOT_PASSWORD: ${DB_ROOT_PASSWORD}
      MYSQL_DATABASE: ${DB_NAME}
      MYSQL_USER: ${DB_USER}
      MYSQL_PASSWORD: ${DB_PASSWORD}
    volumes:
      - mariadb_data:/var/lib/mysql
    healthcheck:
      test: ["CMD", "healthcheck.sh", "--su-mysql", "--connect", "--innodb_initialized"]
      start_period: 1m
      interval: 1m
      timeout: 10s
      retries: 5

  php:
    image: wodby/drupal-php:${PHP_TAG}
    container_name: "${PROJECT_NAME}_php"
    depends_on:
      mariadb:
        condition: service_healthy
    environment:
      PHP_EXTENSIONS_DISABLE: xhprof,spx
      MSMTP_HOST: mailpit
      MSMTP_PORT: 1025
      DB_HOST: ${DB_HOST}
      DB_USER: ${DB_USER}
      DB_PASSWORD: ${DB_PASSWORD}
      DB_NAME: ${DB_NAME}
      DB_DRIVER: ${DB_DRIVER}
    volumes:
      - ./:/var/www/html:cached

  crond:
    init: true
    image: wodby/drupal-php:${PHP_TAG}
    container_name: "${PROJECT_NAME}_crond"
    environment:
      CRONTAB: "0 * * * * drush -r /var/www/html/web cron"
    command: sudo -E crond -f -d 0
    volumes:
      - ./:/var/www/html:cached

  nginx:
    image: wodby/nginx:${NGINX_TAG}
    container_name: "${PROJECT_NAME}_nginx"
    depends_on:
      - php
    environment:
      NGINX_BACKEND_HOST: php
      NGINX_SERVER_ROOT: /var/www/html/web
      NGINX_VHOST_PRESET: ${NGINX_VHOST_PRESET}
      NGINX_STATIC_OPEN_FILE_CACHE: "off"
    volumes:
      - ./:/var/www/html:cached
    ports:
      - "${PROJECT_PORT}:80"

volumes:
  mariadb_data:
```

> **What's happening here:**
> - **MariaDB** runs the database with health checks — PHP won't start until MariaDB reports healthy
> - **PHP-FPM** runs Drupal's PHP code (Wodby's image is preconfigured for Drupal)
> - **Crond** runs `drush cron` every hour in a separate container with `init: true` for proper signal handling
> - **Nginx** reverse-proxies to PHP-FPM and serves static files directly
> - **Named volume** `mariadb_data` persists the database across container restarts

### Install Drupal CMS v2

```bash
# Install Drupal CMS v2 via Composer inside the PHP container
docker compose up -d
docker compose exec php composer create-project drupal/cms .
```

> This pulls Drupal CMS v2 with all its recipes, Canvas, Mercury theme — everything.

### First run

Open `http://your-server-ip:8080` in a browser. You'll see the Drupal installer:

1. Choose language
2. Choose site template: **Starter** (Mercury theme) or **Bite** (dark SaaS theme)
3. Enter database credentials from your `.env` file:
   - Database: `drupal`
   - Username: `drupal`
   - Password: your `DB_PASSWORD`
   - Host: `mariadb` (the Docker service name, not localhost!)
4. Configure site name, admin account
5. Wait for install to complete

> **Common gotcha:** The database host is `mariadb`, not `localhost`. Inside Docker, services talk to each other by service name.

---

## Part 5: Making It Public — Cloudflare Tunnels (~10 min)

### Why Cloudflare Tunnels?

- **Free SSL certificate** — no Certbot, no cron jobs, no renewal anxiety
- **No ports to open** — tunnel creates an outbound-only connection
- **Free CDN** — Cloudflare caches static assets, critical for the 1 GB bandwidth limit on GCP
- **DDoS protection** — free tier includes basic protection
- **Works from anywhere** — home server, VPS, Raspberry Pi

### Setup

1. Create a free Cloudflare account at cloudflare.com
2. Add your domain to Cloudflare (transfer nameservers)
3. Go to **Zero Trust → Networks → Tunnels → Create a tunnel**
4. Name it (e.g., "drupal-eduity")
5. Choose **Debian** and copy the install command

```bash
# Install cloudflared on your server (paste from Cloudflare dashboard)
curl -L --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared.deb
sudo cloudflared service install <YOUR_TUNNEL_TOKEN>
```

6. Back in Cloudflare dashboard, configure the public hostname:
   - **Domain:** `eduity.example.com`
   - **Service:** `HTTP`
   - **URL:** `localhost:8080`

7. Click **Complete Setup**

> That's it. Your Drupal site is now live at `https://eduity.example.com` with full SSL. No ports open. No Certbot. No cron.

### Lock down the firewall

```bash
# Only allow SSH — tunnel handles all web traffic
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw enable

# Verify
sudo ufw status
```

---

## Part 6: Quick Canvas Tour (~5 min)

> Now that we're live, let me show you what makes Drupal CMS v2 worth the extra setup.

### Canvas page builder

- Navigate to **Content → Pages → New Page**
- Drag and drop components: headings, text, images, accordions, hero blocks
- Components are **Single Directory Components** (SDC) — real code, not shortcodes
- Grid layouts: 50/50, 75/25, 100%, three-column
- **Preview** actually works (unlike old Drupal)

### Content templates

- Go to **Canvas → Templates**
- Create a template for any content type
- Map fields dynamically to components
- This replaces the old "Manage Display" page

### Canvas AI (bonus)

- Add an OpenAI API key in Canvas settings
- AI can generate entire page layouts: "Create a pricing page with three tiers"
- AI can create and modify components
- Token usage is tracked in admin

---

## Part 7: Everyday Commands (~3 min)

```bash
# Check container status
docker compose ps

# Run Drush commands
docker compose exec php drush status
docker compose exec php drush cr          # Clear cache
docker compose exec php drush cim -y      # Import config
docker compose exec php drush cex -y      # Export config
docker compose exec php drush updb -y     # Run updates

# Install a new module
docker compose exec php composer require drupal/module_name

# Database backup
docker compose exec mariadb mysqldump -u root -p"$DB_ROOT_PASSWORD" drupal > backup-$(date +%Y%m%d).sql

# Update container images
docker compose pull && docker compose up -d

# View logs
docker compose logs -f php
docker compose logs -f nginx
```

---

## Part 8: Cost Breakdown (~2 min)

| Item | WordPress (typical) | Drupal (typical) | This Setup |
|------|---------------------|-------------------|------------|
| Hosting | $5-30/mo | $10-50/mo | **$0** (GCP free) or **$6/mo** (VPS) |
| SSL | $0-10/mo | $0-10/mo | **$0** (Cloudflare) |
| Domain | $12/yr | $12/yr | **$12/yr** (only real cost) |
| CDN | $0-20/mo | $0-20/mo | **$0** (Cloudflare free tier) |
| Page builder | Free (Gutenberg) | $0 (Canvas) | **$0** |
| AI features | $10-50/mo (plugins) | $0 (Drupal AI module) | **$0** (bring your own API key) |
| **Total/month** | **$5-60** | **$10-80** | **$0-7** |

---

## Closing (~2 min)

> So there it is — Drupal CMS v2 running with Canvas, Tailwind, and AI features, publicly accessible with full SSL, for basically free.
>
> The compose file and .env template are on my GitHub. Link in the chat.
>
> Next stream: we'll customize the Mercury theme for Eduity's branding and build out their 7-page site live. That's the Chattanooga.Digital project — stay tuned.
>
> If this was useful, follow the channel. I stream Drupal, Docker, and web development. TurtleWolfe on Twitch.

---

## Sources

This script synthesizes content from:

| Source | Content Used |
|--------|-------------|
| DevbaseMedia (2018-19) | Original GCP free tier + Docker pattern |
| CavemenTech (2025) | e2-micro specs, Bitnami comparison |
| Tony Teaches Tech (2025-26) | Cloudflare Tunnels, Caddy auto-SSL, modern Docker patterns |
| WebWash — Drupal CMS v2 + Canvas | Canvas UI, SDC components, Canvas AI |
| WebWash — Drupal CMS v1 Install | DDEV, recipes, ECA automation |
| WebWash — Tailwind Theme Setup | Custom Tailwind theme + SDC for Canvas |
| Wodby docker4drupal | Compose patterns, health checks, Drush exec |
| Eduity project engagement | Real-world 7-page site requirements |

All source transcripts available in the TranScripts repo:
- `Docker/WordPress_Free_Forever/WFF_Edited/`
- `Drupal/Drupal_Edited/`
- `Docker/Docker_Edited/docker_php_drupal_compose_patterns.md`
