# Drupal CMS v2 Free Forever — Twitch Stream Script

**Channel:** TurtleWolfe on Twitch
**Format:** Live coding / tutorial stream (~60-75 min)
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

> **Links:**
> - [Google Cloud Console](https://console.cloud.google.com/)
> - [GCP Always Free tier](https://cloud.google.com/free/docs/free-cloud-features#compute)
> - [Tony Teaches Tech — Free GCP Hosting](https://www.youtube.com/watch?v=XNf3d1oi2pM)

```bash
# GCP Always Free tier specs (2025-2026):
# - e2-micro: 2 vCPU, 1 GB RAM
# - 30 GB standard persistent disk
# - 1 GB outbound bandwidth/month
# - US regions only: us-central1, us-west1, us-east1
```

**Create the VM** ([console.cloud.google.com](https://console.cloud.google.com/) → Compute Engine → Create Instance):

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

> **Links:**
> - [Cloudflare Zero Trust Dashboard](https://one.dash.cloudflare.com/)
> - [Tony Teaches Tech — Self-Host with Cloudflare Tunnels](https://www.youtube.com/watch?v=iPlUO9xu36c)
> - [Oracle Cloud Free Tier](https://www.oracle.com/cloud/free/)

This is the better approach for Drupal. Works on:
- A $6/month DigitalOcean/Hetzner VPS (2 GB RAM, comfortable)
- [Oracle Cloud free tier](https://www.oracle.com/cloud/free/) (4 CPU + 24 GB ARM — very generous)
- A Raspberry Pi at home
- Your existing development machine

> I'm going with Path B because my client Eduity already has a server with Portainer. But the Docker Compose file is identical either way.
>
> Either way, we have a deploy script that automates the whole thing — swap, Docker, firewall, the works. It's `scripts/deploy-gcp.sh` in the repo. Adapted from our WordPress deployment script.

---

## Part 3: Docker + Docker Compose Setup (~5 min)

### Install Docker ([docs.docker.com/engine/install](https://docs.docker.com/engine/install/))

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

We need two files: `.env` for secrets and `compose.yaml` for the stack.

> **Note:** Docker Compose v2 uses `compose.yaml` as the default filename. The old `docker-compose.yml` still works but `compose.yaml` is the modern convention.

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

> **Links:**
> - [Wodby Docker4Drupal](https://github.com/wodby/docker4drupal)
> - [Drupal CMS v2](https://www.drupal.org/project/drupal_cms)
> - [Wodby Drupal CMS image](https://hub.docker.com/r/wodby/drupal-cms)
> - [Docker Compose file reference](https://docs.docker.com/reference/compose-file/)

### The compose.yaml baseline walkthrough

```bash
nano compose.yaml
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
    image: wodby/drupal-cms:${PHP_TAG}
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
    image: wodby/drupal-cms:${PHP_TAG}
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

## Part 4b: Production Evolution — Chattanooga.Digital (~10 min)

> That baseline works great for getting started. But for a real client project, we need persistence, backups, and reproducibility. Here's what our actual `compose.yaml` looks like for the Chattanooga.Digital / Eduity project.

### What changed and why

```yaml
services:
  mariadb:
    image: wodby/mariadb:${MARIADB_TAG}         # Pinned: 11.4-3.34.5
    volumes:
      - drupal_db_data:/var/lib/mysql
      # NEW: Database snapshot auto-restores on first boot (empty data dir)
      - ./db-snapshot.sql.gz:/docker-entrypoint-initdb.d/01-snapshot.sql.gz:ro
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]  # Simpler than baseline

  php:
    image: wodby/drupal-cms:${DRUPAL_CMS_TAG}    # Pinned: 2-1.3.5 (not drupal-php!)
    volumes:
      - drupal_codebase:/var/www/html
      # NEW: Bind mounts for persistence and customization
      - ./themes/byte_theme:/var/www/html/web/themes/contrib/byte_theme
      - ./modules/byte_menu:/var/www/html/web/modules/custom/byte_menu
      - ./files:/var/www/html/web/sites/default/files
      - ./scripts/add-trusted-hosts.sh:/docker-entrypoint-init.d/30-trusted-hosts.sh:ro

  crond:
    image: wodby/drupal-cms:${DRUPAL_CMS_TAG}
    environment:
      CRONTAB: "0 * * * * drush -r /var/www/html/web cron\n0 3 * * 0 /usr/local/bin/backup-offsite.sh"
    volumes:
      # NEW: Backup script for weekly GitHub Releases upload
      - ./scripts/backup-offsite.sh:/usr/local/bin/backup-offsite.sh:ro

  nginx:
    image: wodby/nginx:${NGINX_TAG}              # Pinned: 1.28-5.46.8
    ports:
      - "${DRUPAL_PORT:-8080}:80"

volumes:
  drupal_db_data:     # Database — survives 'down', wiped by 'down -v' (auto-restores)
  drupal_codebase:    # Drupal code — survives 'down', wiped by 'down -v' (Wodby reprovisions)
```

> **Key differences from baseline:**
>
> 1. **`drupal-cms` image** instead of `drupal-php` — includes Composer, Drupal CMS recipes, everything pre-installed
> 2. **DB snapshot auto-restore** — `db-snapshot.sql.gz` mounted to MariaDB's initdb. Destroy volumes? It rebuilds automatically
> 3. **Theme bind mount** — edit theme files on host, reflected in container immediately. But Wodby overwrites on fresh boot! `start.sh` runs `git checkout` to restore
> 4. **Files bind mount** — uploaded images persist in `./files/`, survives even `docker compose down -v`
> 5. **Custom module bind mount** — `byte_menu` Twig extension lives in the repo, not inside the container
> 6. **Weekly backup cron** — `backup-offsite.sh` dumps the DB and uploads to GitHub Releases every Sunday at 3 AM

### The Makefile

```bash
make up          # ./scripts/start.sh (boot + restore + CSS rebuild)
make down        # docker compose down (keep data)
make destroy     # docker compose down -v (wipe + auto-restore from snapshot)
make restart     # destroy + up
make snapshot    # drush sql:dump + tar files/ (save current state)
make backup      # manual DB backup to files/backups/
make logs        # tail PHP logs
make shell       # bash into PHP container
make status      # docker compose ps
```

### Persistence model

| Component | Survives `down`? | Survives `down -v`? | How? |
|-----------|:---:|:---:|------|
| Database | Yes | No → auto-restores | `db-snapshot.sql.gz` via initdb |
| Uploaded files | Yes | Yes | `./files/` bind mount |
| Theme | Yes | Yes | `./themes/byte_theme/` bind mount + `git checkout` |
| Custom module | Yes | Yes | `./modules/byte_menu/` bind mount |
| Drupal core | Yes | No → Wodby reprovisions | `drupal_codebase` volume |

> Run `make destroy && make up` — your entire site comes back exactly as it was. That's the persistence model.

---

## Part 5: Making It Public — Cloudflare Tunnels (~10 min)

### Why Cloudflare Tunnels?

- **Free SSL certificate** — no Certbot, no cron jobs, no renewal anxiety
- **No ports to open** — tunnel creates an outbound-only connection
- **Free CDN** — Cloudflare caches static assets, critical for the 1 GB bandwidth limit on GCP
- **DDoS protection** — free tier includes basic protection
- **Works from anywhere** — home server, VPS, Raspberry Pi

### Setup

1. Create a free Cloudflare account at [cloudflare.com](https://www.cloudflare.com/)
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

## Part 6: Chattanooga.Digital Canvas Tour (~5 min)

> Now let me show you the actual Eduity site we built. This is Chattanooga.Digital — the real client project.

### What Byte recipe gives you out of the box

- **Hero billboard** with background image, overlay opacity, content positioning
- **Service cards** — four cards linking to individual Canvas pages (Smart Planning, Job Mapping, Complete Stack, Chattanooga.Digital)
- **Community Partners** section
- **Testimonials** carousel
- **Blog latest posts** — auto-populated from blog content type (Views block inside Canvas)
- **CTA** with dual buttons
- All dark theme, Tailwind CSS, mobile responsive

### What we added for the client (appended, not replaced)

- **"What is Eduity?"** — intro section with client's copy
- **Digital Development** — side-by-side layout with SVG graph (automate → customize → innovate)
- **Job Mapping** — expanded description with O*NET reference
- **Smart Planning** — side-by-side with process diagram SVG + interactive accordion (3 steps with practices)
- **Technology Leadership** — section with CTA
- **Benefits** — 3 audience cards (Individuals, Companies, Regions) + 4 benefit cards with [Phosphor icons](https://phosphoricons.com/)
- **"Who is Eduity?"** — company section

### Anchor navigation

- Menu has `Benefits` → `/#benefits` and `Company` → `/#company` — scroll to sections on the homepage
- Existing page links (Services, Blog, About, Contact) still go to their own pages — nothing was removed

### Contact form customization

- Added "I would like to" radios: Get in Touch / Newsletter
- Added "I am interested in" checkboxes: Chattanooga.Digital, Digital Development, Job Mapping, Smart Planning, Technology Leadership, Other
- Existing fields (name, email, message, captcha) untouched

### Canvas AI (bonus)

- Add an OpenAI API key in Canvas settings
- AI can generate entire page layouts: "Create a pricing page with three tiers"
- AI can create and modify components
- Token usage is tracked in admin

---

## Part 7: Everyday Commands (~3 min)

### With the Makefile

```bash
make up          # Start (auto-restores DB, theme, CSS)
make down        # Stop (keep data)
make destroy     # Stop + wipe volumes (auto-restores on next up)
make snapshot    # Save current DB + files to committed snapshots
make backup      # Manual DB backup to files/backups/
make logs        # Tail PHP logs
make shell       # Bash into PHP container
make status      # Container health
```

### Direct Docker commands

```bash
# Run Drush commands
docker compose exec php drush status
docker compose exec php drush cr          # Clear cache
docker compose exec php drush uli --uri=http://localhost:8080  # Admin login link

# Install a new module
docker compose exec php composer require drupal/module_name

# View logs
docker compose logs -f php
docker compose logs -f nginx
```

---

## Part 8: Programmatic Content with Drush (~5 min)

> Canvas drag-and-drop works great for manual editing. But for automation — adding 50 components from a client's Word doc — we use Drush PHP scripts.

### Why programmatic?

- Canvas drag-and-drop via Playwright is unreliable (components miss drop zones)
- Client sends content in ODT/DOCX — we need to batch-process it
- Reproducible: `make destroy && make up` restores everything from the snapshot

### The pattern: `scripts/build-homepage.php`

```php
// Load the existing page — don't replace, APPEND
$page = \Drupal::entityTypeManager()->getStorage('canvas_page')->load(8);

// Build a component
$tree[] = [
  'uuid' => \Drupal::service('uuid')->generate(),
  'component_id' => 'sdc.byte_theme.section',
  'component_version' => 'a917d5c9be8f2830',  // From canvas.component config
  'inputs' => json_encode([...]),
  'parent_uuid' => NULL,  // MUST be NULL for root items, not empty string!
  'slot' => '',
];

// Append (not replace!)
foreach ($tree as $item) {
  $page->get('components')->appendItem($item);
}
$page->save();
```

### Key gotchas we learned

- **`parent_uuid` must be NULL** for root components — empty string `""` bypasses PHP's `??` null coalescing and causes a 500 error
- **Component versions are hashes**, not semver — query `canvas.component.sdc.byte_theme.*` config for `active_version`
- **Text components require `text_size` and `text_color`** — they're mandatory even though the schema doesn't make it obvious
- **SVG images need media entities** — create `file` + `media` (type: `svg_image`) entities, reference by media ID
- **SVG text on dark themes** — change `fill="rgb(0,0,0)"` to white, add `object-contain` CSS to prevent clipping

---

## Part 9: Real-World Client Workflow (~5 min)

> Here's how an actual client content update works, end to end.

### The flow

1. **Client emails** ODT file + SVG/PNG diagrams
2. **Extract content** — Python to read ODT XML, copy images to `files/`
3. **Create media entities** — `drush php:eval` to register SVGs as Drupal media
4. **Write append script** — PHP that adds Canvas components after existing content
5. **Fix for dark theme** — SVG black text → white, add `object-contain` CSS
6. **Add menu links** — `menu_link_content` entities (additive, don't delete existing!)
7. **Customize webform** — add interest-area checkboxes to contact form
8. **Snapshot** — `make snapshot` saves DB + files
9. **Verify persistence** — `make destroy && make up` — everything comes back

> Total: 46 components appended, 2 menu links added, 2 form fields added, 2 SVGs fixed. Zero existing content touched.

---

## Part 10: Cost Breakdown (~2 min)

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
> The compose file and .env template are on my GitHub: [github.com/TortoiseWolfe/drupal-v2-sandbox](https://github.com/TortoiseWolfe/drupal-v2-sandbox). Link in the chat.
>
> Next stream: we'll customize the Mercury theme for Eduity's branding and build out their 7-page site live. That's the Chattanooga.Digital project — stay tuned.
>
> If this was useful, follow the channel. I stream Drupal, Docker, and web development. TurtleWolfe on Twitch.

---

## Sources

This script synthesizes content from:

| Source | Content Used | Link |
|--------|-------------|------|
| DevbaseMedia (2018-19) | Original GCP free tier + Docker pattern | [YouTube playlist](https://www.youtube.com/watch?v=5YkkqjwRqN4) |
| CavemenTech (2025) | e2-micro specs, Bitnami comparison | [YouTube](https://www.youtube.com/watch?v=oGxNMB6gFGY) |
| Tony Teaches Tech (2025-26) | Cloudflare Tunnels, Caddy auto-SSL, Docker | [GCP video](https://www.youtube.com/watch?v=XNf3d1oi2pM) / [Tunnels video](https://www.youtube.com/watch?v=iPlUO9xu36c) |
| WebWash — Drupal CMS v2 + Canvas | Canvas UI, SDC components, Canvas AI | [webwash.net](https://www.webwash.net/) |
| WebWash — Drupal CMS v1 Install | DDEV, recipes, ECA automation | [webwash.net](https://www.webwash.net/) |
| WebWash — Tailwind Theme Setup | Custom Tailwind theme + SDC for Canvas | [webwash.net](https://www.webwash.net/) |
| Wodby docker4drupal | Compose patterns, health checks, Drush exec | [github.com/wodby/docker4drupal](https://github.com/wodby/docker4drupal) |
| Eduity project engagement | Real-world 7-page site requirements | — |
| TortoiseWolfe/GCP `boot.sh` | GCP VM bootstrap (swap, Docker, Secret Manager) | [github.com/TortoiseWolfe/GCP](https://github.com/TortoiseWolfe/GCP) |
| TortoiseWolfe/wp-dev `enhanced-boot.sh` | Production deploy script | [github.com/TortoiseWolfe/wp-dev](https://github.com/TortoiseWolfe/wp-dev) |
| Drupal CMS v2 | The CMS itself | [drupal.org/project/drupal_cms](https://www.drupal.org/project/drupal_cms) |
| Cloudflare Zero Trust | Free tunnels + SSL + CDN | [one.dash.cloudflare.com](https://one.dash.cloudflare.com/) |
| Chattanooga.Digital session (2026-03-25) | Programmatic Canvas content, SVG fixes, persistence model | [github.com/TortoiseWolfe/drupal-v2-sandbox](https://github.com/TortoiseWolfe/drupal-v2-sandbox) |

All source transcripts available in the TranScripts repo:
- `Docker/WordPress_Free_Forever/WFF_Edited/`
- `Drupal/Drupal_Edited/`
- `Docker/Docker_Edited/docker_php_drupal_compose_patterns.md`
