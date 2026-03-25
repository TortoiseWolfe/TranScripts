# Docker Compose Patterns for PHP/Drupal Stacks

**Source:** Wodby docker4drupal, Docker official docs, php-fpm-healthcheck project, MariaDB docs
**Purpose:** Fill gaps in the Node.js-focused Docker knowledge base for PHP/Drupal projects

---

## G1: Health Check Patterns for PHP-FPM and MariaDB

### PHP-FPM Health Check

Use the `php-fpm-healthcheck` script — a POSIX-compliant shell utility that queries PHP-FPM's status page via `cgi-fcgi`.

**Install in Dockerfile:**

```dockerfile
RUN wget -O /usr/local/bin/php-fpm-healthcheck \
    https://raw.githubusercontent.com/renatomefi/php-fpm-healthcheck/master/php-fpm-healthcheck && \
    chmod +x /usr/local/bin/php-fpm-healthcheck
```

**Enable the status endpoint in PHP-FPM config:**

```ini
pm.status_path = /status
```

**Dockerfile HEALTHCHECK:**

```dockerfile
HEALTHCHECK --interval=5s --timeout=1s \
    CMD php-fpm-healthcheck || exit 1
```

**With metric thresholds:**

```bash
php-fpm-healthcheck --accepted-conn=3000 --listen-queue=10
```

**Alternative (no extra script):**

```yaml
healthcheck:
  test: ["CMD-SHELL", "php -r 'if (@fsockopen(\"127.0.0.1\", 9000)) exit(0); else exit(1);'"]
  interval: 20s
  timeout: 5s
  retries: 3
```

### MariaDB Health Check

Modern MariaDB images ship with `healthcheck.sh`:

```yaml
mariadb:
  image: wodby/mariadb:11
  healthcheck:
    test: ["CMD", "healthcheck.sh", "--su-mysql", "--connect", "--innodb_initialized"]
    start_period: 1m
    interval: 1m
    timeout: 10s
    retries: 5
```

**For MySQL or older MariaDB:**

```yaml
healthcheck:
  test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "root", "-p$$MYSQL_ROOT_PASSWORD"]
  interval: 10s
  timeout: 5s
  retries: 10
```

### Dependency Ordering with Health Checks

Docker Compose v2 supports `condition: service_healthy`:

```yaml
php:
  depends_on:
    mariadb:
      condition: service_healthy
```

This ensures PHP won't start until MariaDB reports healthy — critical for Drupal install steps.

---

## G2: Multi-Service Compose for PHP + Nginx + DB

The canonical Drupal Docker stack (from `wodby/docker4drupal`) separates concerns into 5+ services:

```yaml
services:
  mariadb:
    image: wodby/mariadb:$MARIADB_TAG
    stop_grace_period: 30s
    environment:
      MYSQL_ROOT_PASSWORD: $DB_ROOT_PASSWORD
      MYSQL_DATABASE: $DB_NAME
      MYSQL_USER: $DB_USER
      MYSQL_PASSWORD: $DB_PASSWORD

  php:
    image: wodby/drupal-php:$PHP_TAG
    environment:
      PHP_EXTENSIONS_DISABLE: xhprof,spx
      MSMTP_HOST: mailpit
      MSMTP_PORT: 1025
    volumes:
      - ./:/var/www/html:cached

  crond:
    init: true
    image: wodby/drupal-php:$PHP_TAG
    environment:
      CRONTAB: "0 * * * * drush -r /var/www/html/web cron"
    command: sudo -E crond -f -d 0
    volumes:
      - ./:/var/www/html:cached

  nginx:
    image: wodby/nginx:$NGINX_TAG
    depends_on:
      - php
    environment:
      NGINX_BACKEND_HOST: php
      NGINX_SERVER_ROOT: /var/www/html/web
      NGINX_VHOST_PRESET: $NGINX_VHOST_PRESET
    volumes:
      - ./:/var/www/html:cached
    labels:
      - "traefik.http.routers.${PROJECT_NAME}_nginx.rule=Host(`${PROJECT_BASE_URL}`)"

  traefik:
    image: traefik:v3
    command: --api.insecure=true --providers.docker
    ports:
      - "${PROJECT_PORT}:80"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
```

**Key architecture decisions:**
- **PHP and Nginx are separate containers** — Nginx proxies to PHP-FPM via `NGINX_BACKEND_HOST: php`
- **Crond is a separate PHP container** — runs `drush cron` on schedule, uses `init: true` for proper signal handling
- **Traefik handles routing** — no port mapping on individual services, all via labels
- **PHP user:** `www-data` (uid 82) for FPM, `wodby` (uid 1000) for CLI

---

## G3: Bind-Mount Customization of Pre-Built Images (Wodby Pattern)

Wodby images are **preconfigured** — you customize them via environment variables, not by editing config files.

### PHP Image Customization

```yaml
php:
  image: wodby/drupal-php:$PHP_TAG
  environment:
    # Xdebug
    PHP_XDEBUG_MODE: debug
    PHP_XDEBUG_START_WITH_REQUEST: "yes"
    PHP_IDE_CONFIG: serverName=my-ide
    # FPM tuning
    PHP_FPM_USER: wodby
    PHP_FPM_GROUP: wodby
    # Mail
    MSMTP_HOST: mailpit
    MSMTP_PORT: 1025
```

### Nginx Image Customization

```yaml
nginx:
  image: wodby/nginx:$NGINX_TAG
  environment:
    NGINX_BACKEND_HOST: php
    NGINX_SERVER_ROOT: /var/www/html/web
    NGINX_VHOST_PRESET: drupal11          # drupal7, drupal8, drupal9, drupal10, drupal11
    NGINX_STATIC_OPEN_FILE_CACHE: "off"   # Disable for dev
    NGINX_ERROR_LOG_LEVEL: debug
    # NGINX_DRUPAL_FILE_PROXY_URL: http://example.com  # Proxy remote files in dev
```

### When You Need Custom Config Files

For edge cases not covered by env vars, mount config snippets:

```yaml
nginx:
  volumes:
    - ./nginx-custom.conf:/etc/nginx/conf.d/custom.conf:ro
```

**Rule of thumb:** Check Wodby's environment variable list first — they cover 90%+ of common customizations. Only bind-mount config files for truly custom needs.

---

## G4: Volume Persistence Patterns for Database Containers

### Named Volumes (Default, Recommended for Dev)

```yaml
services:
  mariadb:
    image: wodby/mariadb:11
    volumes:
      - mariadb_data:/var/lib/mysql

volumes:
  mariadb_data:
```

- **Survives** `docker compose stop` and `docker compose start`
- **Survives** `docker compose down`
- **Destroyed by** `docker compose down -v` (the `-v` flag deletes volumes)

### Bind Mounts (Full Control)

```yaml
mariadb:
  volumes:
    - /path/to/mariadb/data/on/host:/var/lib/mysql
```

- Data visible on host filesystem
- Easy to backup with standard tools
- Permission issues possible (uid/gid mismatch)

### Database Initialization

Place `.sql`, `.sql.gz`, or `.sh` files in a mount directory:

```yaml
mariadb:
  volumes:
    - ./mariadb-init:/docker-entrypoint-initdb.d
```

Files execute **only on first startup** when the data directory is empty.

### Backup Patterns

**SQL dump (recommended):**

```bash
docker compose exec mariadb mysqldump -u root -p"$DB_ROOT_PASSWORD" $DB_NAME > backup.sql
```

**Volume archive:**

```bash
docker run --rm -v project_mariadb_data:/data -v $(pwd):/backup alpine \
  tar czf /backup/mariadb-backup.tar.gz -C /data .
```

---

## G5: .env Interpolation Gotchas

### Docker Compose auto-loads `.env`

A `.env` file in the same directory as `compose.yml` is automatically loaded. Variables are available for `${VAR}` interpolation in the compose file.

### Common Gotchas

**Dollar signs in passwords:**

```env
# WRONG — Compose interprets $ecret as a variable
DB_PASSWORD=my$ecretPass

# RIGHT — Escape with double dollar
DB_PASSWORD=my$$ecretPass

# RIGHT — Or use single quotes in compose.yml environment block
```

**URL-encoded special characters:**

```env
# If your password has @, #, %, use URL encoding in connection strings
# @ = %40, # = %23, % = %25
DATABASE_URL=mysql://user:p%40ss%23word@mariadb:3306/drupal
```

**Variable precedence (highest to lowest):**
1. Shell environment variables
2. `.env` file
3. `env_file:` directive in compose
4. `environment:` block defaults in compose

**Never commit `.env` — commit `.env.example` instead:**

```env
# .env.example — copy to .env and fill in values
PROJECT_NAME=my_project
PROJECT_BASE_URL=drupal.docker.localhost
PROJECT_PORT=8000
DB_NAME=drupal
DB_USER=drupal
DB_PASSWORD=changeme
DB_ROOT_PASSWORD=changeme
```

### Secrets vs Environment Variables

For production, use Docker secrets or a vault. Environment variables are visible in:
- `docker inspect`
- `/proc/1/environ` inside the container
- Build history (if used in `ARG`/`ENV` during build)

---

## G6: Traefik Reverse Proxy Integration

### How Wodby Uses Traefik

The docker4drupal stack includes Traefik v3 for local routing:

```yaml
traefik:
  image: traefik:v3
  command: --api.insecure=true --providers.docker
  ports:
    - "${PROJECT_PORT}:80"
  volumes:
    - /var/run/docker.sock:/var/run/docker.sock
```

**Traefik discovers services via Docker labels:**

```yaml
nginx:
  labels:
    - "traefik.http.routers.${PROJECT_NAME}_nginx.rule=Host(`${PROJECT_BASE_URL}`)"

mailpit:
  labels:
    - "traefik.http.services.${PROJECT_NAME}_mailpit.loadbalancer.server.port=8025"
    - "traefik.http.routers.${PROJECT_NAME}_mailpit.rule=Host(`mailpit.${PROJECT_BASE_URL}`)"
```

### Multi-Project Setup (Single Traefik)

Run one Traefik instance that routes to multiple project stacks:

1. Create a standalone `traefik.yml`:

```yaml
services:
  traefik:
    image: traefik:v3
    command: --api.insecure=true --providers.docker
    ports:
      - "80:80"
      - "8080:8080"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    networks:
      - project_a_default
      - project_b_default

networks:
  project_a_default:
    external: true
  project_b_default:
    external: true
```

2. Remove `traefik` service and port mappings from individual project compose files.
3. Start standalone Traefik: `docker compose -f traefik.yml up -d`

### Production Traefik (with SSL)

For production, add Let's Encrypt:

```yaml
traefik:
  image: traefik:v3
  command:
    - --providers.docker
    - --entrypoints.web.address=:80
    - --entrypoints.websecure.address=:443
    - --certificatesresolvers.letsencrypt.acme.email=you@example.com
    - --certificatesresolvers.letsencrypt.acme.storage=/acme.json
    - --certificatesresolvers.letsencrypt.acme.httpchallenge.entrypoint=web
  ports:
    - "80:80"
    - "443:443"
  volumes:
    - /var/run/docker.sock:/var/run/docker.sock
    - ./acme.json:/acme.json
```

---

## G7: Docker Compose `--profile` Flag

Profiles let you group optional services that only start when explicitly requested.

### Defining Profiles

```yaml
services:
  mariadb:
    image: wodby/mariadb:11
    # No profile — always starts

  php:
    image: wodby/drupal-php:8.3
    # No profile — always starts

  adminer:
    image: wodby/adminer
    profiles:
      - debug
    labels:
      - "traefik.http.routers.adminer.rule=Host(`adminer.${PROJECT_BASE_URL}`)"

  mailpit:
    image: axllent/mailpit
    profiles:
      - debug
      - mail

  xhprof:
    image: wodby/xhprof
    profiles:
      - profiling
```

### Usage

```bash
# Start core services only
docker compose up -d

# Start core + debug tools (adminer, mailpit)
docker compose --profile debug up -d

# Start core + profiling
docker compose --profile profiling up -d

# Multiple profiles
docker compose --profile debug --profile profiling up -d
```

### Environment Variable Alternative

```bash
export COMPOSE_PROFILES=debug,mail
docker compose up -d
```

**Use cases for the Eduity project:**
- `debug` profile: Adminer, Mailpit, Xdebug-enabled PHP
- `profiling` profile: XHProf, Webgrind
- `search` profile: Solr, Zookeeper

---

## G8: `docker compose exec` Patterns for Drush and One-Off Commands

### Running Drush Commands

```bash
# Standard Drush command
docker compose exec php drush status

# Drush cache rebuild
docker compose exec php drush cr

# Drush site install
docker compose exec php drush si --db-url=mysql://drupal:drupal@mariadb/drupal

# Import configuration
docker compose exec php drush cim -y

# Export configuration
docker compose exec php drush cex -y

# Run database updates
docker compose exec php drush updb -y

# Run cron manually
docker compose exec php drush cron
```

### Composer Commands

```bash
# Install dependencies
docker compose exec php composer install

# Require a new module
docker compose exec php composer require drupal/module_name

# Update Drupal core
docker compose exec php composer update drupal/core-* --with-dependencies
```

### Interactive Shell

```bash
# Bash shell in PHP container
docker compose exec php bash

# As root (for installing packages)
docker compose exec --user root php bash
```

### Database Operations

```bash
# MySQL CLI
docker compose exec mariadb mysql -u drupal -pdrupal drupal

# Database dump
docker compose exec mariadb mysqldump -u root -p"$DB_ROOT_PASSWORD" drupal > backup.sql

# Import database
docker compose exec -T mariadb mysql -u root -p"$DB_ROOT_PASSWORD" drupal < backup.sql
```

**Note the `-T` flag** — required when piping input to `exec` (disables pseudo-TTY).

### Wodby Makefile Shortcuts

The docker4drupal Makefile provides shortcuts:

```bash
make drush status        # → docker compose exec php drush status
make shell               # → docker compose exec php bash
make logs                # → docker compose logs -f
```

---

## G9: Image Update and `docker compose pull` Workflow

### Updating Container Images

```bash
# Pull latest images for all services
docker compose pull

# Pull specific service
docker compose pull php

# Recreate containers with new images
docker compose up -d

# One-liner: pull + recreate
docker compose pull && docker compose up -d
```

### Understanding Image Tags

```env
# .env file — pin versions, don't use :latest
MARIADB_TAG=11
PHP_TAG=8.3-dev-4.x
NGINX_TAG=1.27
```

**Wodby tag convention:** `<version>-<variant>-<wodby-release>`
- `8.3-dev-4.x` = PHP 8.3, dev variant (includes Xdebug), Wodby 4.x branch
- `8.3-4.x` = PHP 8.3, production variant

### Safe Update Workflow

```bash
# 1. Check what will change
docker compose pull --dry-run

# 2. Pull new images
docker compose pull

# 3. Backup database first
docker compose exec mariadb mysqldump -u root -p"$DB_ROOT_PASSWORD" drupal > backup-$(date +%Y%m%d).sql

# 4. Recreate containers
docker compose up -d

# 5. Run Drupal updates
docker compose exec php drush updb -y
docker compose exec php drush cr
```

### Cleanup Old Images

```bash
# Remove unused images
docker image prune

# Remove all unused images (not just dangling)
docker image prune -a

# Remove everything unused (containers, networks, images, volumes)
docker system prune
# CAUTION: Add --volumes to also remove unused volumes
```
