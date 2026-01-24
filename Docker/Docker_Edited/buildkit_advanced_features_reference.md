# BuildKit Advanced Features Reference

This reference covers BuildKit features for secure, efficient Docker builds. These patterns are essential for production Node.js applications that need private dependencies or optimized build times.

> **Prerequisite:** Docker Engine v23+ (Feb 2023) has BuildKit enabled by default. Always include `# syntax=docker/dockerfile:1` as the first line for latest features.

---

## 1. Secret Mounts

Secrets are temporarily available during build instructions only—never baked into the final image.

### npm Token for Private Packages

**Dockerfile:**
```dockerfile
# syntax=docker/dockerfile:1
FROM node:22-bookworm-slim AS base
WORKDIR /app

# Secret is only available during this RUN instruction
RUN --mount=type=secret,id=npm_token \
    NPM_TOKEN=$(cat /run/secrets/npm_token) \
    npm ci --omit dev
```

**Build command:**
```bash
# Create token file (not committed to git)
echo "npm_xxxxxxxxxxxx" > .npm_token

# Build with secret
docker build --secret id=npm_token,src=.npm_token -t myapp .
```

### .npmrc File for Private Registry

**Dockerfile:**
```dockerfile
# syntax=docker/dockerfile:1
FROM node:22-bookworm-slim AS base
WORKDIR /app
COPY package*.json ./

# Mount .npmrc temporarily at expected location
RUN --mount=type=secret,id=npmrc,target=/root/.npmrc \
    npm ci --omit dev
```

**Build command:**
```bash
docker build --secret id=npmrc,src=.npmrc -t myapp .
```

### With Docker Compose

**compose.yaml:**
```yaml
services:
  app:
    build:
      context: .
      secrets:
        - npm_token

secrets:
  npm_token:
    file: .npm_token
```

```bash
docker compose build
```

---

## 2. SSH Mounts

Forward SSH keys for accessing private Git repositories without copying keys into the image.

### Clone Private Repository

**Dockerfile:**
```dockerfile
# syntax=docker/dockerfile:1
FROM node:22-bookworm-slim AS base
WORKDIR /app

# Install git (required for SSH clone)
RUN apt-get update && apt-get install -y --no-install-recommends git openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Clone private repo (SSH key forwarded, not copied)
RUN --mount=type=ssh \
    mkdir -p /root/.ssh && \
    ssh-keyscan github.com >> /root/.ssh/known_hosts && \
    git clone git@github.com:myorg/private-repo.git /app/private-repo
```

**Build command:**
```bash
# Uses default SSH agent
docker build --ssh default -t myapp .

# Or specify a key file
docker build --ssh default=$HOME/.ssh/id_ed25519 -t myapp .
```

### Install Private npm Package via Git+SSH

**Dockerfile:**
```dockerfile
# syntax=docker/dockerfile:1
FROM node:22-bookworm-slim AS base
WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends git openssh-client \
    && rm -rf /var/lib/apt/lists/*

COPY package*.json ./

# package.json has: "private-pkg": "git+ssh://git@github.com:myorg/private-pkg.git"
RUN --mount=type=ssh \
    mkdir -p /root/.ssh && \
    ssh-keyscan github.com >> /root/.ssh/known_hosts && \
    npm ci --omit dev
```

---

## 3. Cache Mounts

Persist cache between builds without including it in image layers.

### npm Cache

```dockerfile
# syntax=docker/dockerfile:1
FROM node:22-bookworm-slim AS base
WORKDIR /app
COPY package*.json ./

# npm cache persists between builds
RUN --mount=type=cache,target=/root/.npm \
    npm ci --omit dev
```

### Multiple Cache Mounts

```dockerfile
# syntax=docker/dockerfile:1
FROM node:22-bookworm-slim AS base

# Cache apt packages
RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt \
    apt-get update && apt-get install -y tini

WORKDIR /app
COPY package*.json ./

# Cache npm packages
RUN --mount=type=cache,target=/root/.npm \
    npm ci --omit dev
```

---

## 4. Compose Multi-Stage Targeting

Use the same Dockerfile for development, testing, and production.

### Basic Pattern

**Dockerfile:**
```dockerfile
# syntax=docker/dockerfile:1

FROM node:22-bookworm-slim AS base
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit dev

FROM base AS dev
RUN npm install
CMD ["nodemon", "server.js"]

FROM base AS test
COPY --from=dev /app/node_modules ./node_modules
COPY . .
RUN npm run lint && npm test

FROM base AS prod
COPY . .
CMD ["node", "server.js"]
```

**compose.yaml (development):**
```yaml
services:
  app:
    build:
      context: .
      target: dev
    ports:
      - "3000:3000"
    volumes:
      - .:/app
      - /app/node_modules
    environment:
      - NODE_ENV=development
```

**compose.prod.yaml:**
```yaml
services:
  app:
    build:
      context: .
      target: prod
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
```

### Commands

```bash
# Development
docker compose up --build

# Production
docker compose -f compose.prod.yaml up --build

# CI: Run tests only
docker build --target test -t myapp:test .

# CI: Build production image
docker build --target prod -t myapp:prod .
```

---

## 5. Combining Features

### Full Example: Private Packages + Multi-Stage

**Dockerfile:**
```dockerfile
# syntax=docker/dockerfile:1

# Base with production dependencies
FROM node:22-bookworm-slim AS base
RUN apt-get update && apt-get install -y --no-install-recommends tini \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY package*.json ./

# Production deps with private npm token
RUN --mount=type=secret,id=npm_token \
    --mount=type=cache,target=/root/.npm \
    NPM_TOKEN=$(cat /run/secrets/npm_token) npm ci --omit dev

# Dev stage: all dependencies
FROM base AS dev
RUN --mount=type=secret,id=npm_token \
    --mount=type=cache,target=/root/.npm \
    NPM_TOKEN=$(cat /run/secrets/npm_token) npm install
CMD ["nodemon", "server.js"]

# Source stage: add code
FROM base AS source
COPY . .

# Test stage: run linting and tests
FROM source AS test
COPY --from=dev /app/node_modules ./node_modules
RUN npm run lint && npm test

# Production stage: clean, tested image
FROM source AS prod
USER node
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["node", "server.js"]
```

**Build:**
```bash
# Test (with secret for potential private test deps)
docker build --secret id=npm_token,src=.npm_token --target test -t myapp:test .

# Production
docker build --secret id=npm_token,src=.npm_token --target prod -t myapp:prod .
```

---

## Quick Reference

| Feature | Dockerfile Syntax | Build Flag |
|---------|------------------|------------|
| Secret mount | `--mount=type=secret,id=xxx` | `--secret id=xxx,src=file` |
| SSH mount | `--mount=type=ssh` | `--ssh default` |
| Cache mount | `--mount=type=cache,target=/path` | (none needed) |
| Stage target | (in Dockerfile) | `--target stagename` |

## Sources

- [Docker Build Secrets](https://docs.docker.com/build/building/secrets/)
- [Docker SSH Mounts](https://docs.docker.com/build/building/secrets/#ssh-mounts)
- [Compose Build Specification](https://docs.docker.com/reference/compose-file/build/)
- [Nick Janetakis: Build Secrets](https://nickjanetakis.com/blog/mount-secure-build-time-secrets-with-docker-and-docker-compose)
