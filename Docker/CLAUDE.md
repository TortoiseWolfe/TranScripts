# Docker — CLAUDE.md

## Purpose

Docker and DevOps best practices transcripts, primarily from Bret Fisher's talks and Node.js Docker content.

## Structure

```
Docker/
├── *.txt                          # Raw transcripts (Bret Fisher talks)
├── Docker_Edited/                 # Cleaned transcripts + system prompt
│   └── DOCKER_SYSTEM_PROMPT.md
└── WordPress_Free_Forever/        # Free hosting series (isolated)
    ├── *.txt                      # Raw transcripts (DevbaseMedia, CavemenTech, Tony Teaches Tech)
    └── WFF_Edited/                # Cleaned transcripts
```

## Key Files

- `Docker_Edited/DOCKER_SYSTEM_PROMPT.md` — System prompt for Docker best practices project

## Docker_Edited — Cleaned Transcripts

| File | Source |
|------|--------|
| `docker_production_best_practices_dockercon2017.md` | Bret Fisher, DockerCon 2017 |
| `docktalk_nodejs_best_practices_2020.md` | Bret Fisher, 2020 |
| `late_night_docker_ama_nodejs_2018.md` | Bret Fisher AMA, 2018 |
| `nodejs_rocks_in_docker_dockercon2022.md` | Bret Fisher, DockerCon 2022 |
| `nodejs_rocks_in_docker_dockercon2023.md` | Bret Fisher, DockerCon 2023 |
| `buildkit_advanced_features_reference.md` | BuildKit reference |
| `nextjs_docker_best_practices_2025.md` | Next.js Docker guide |
| `docker_php_drupal_compose_patterns.md` | PHP/Drupal Compose patterns (health checks, Traefik, volumes, profiles, exec) |
| `openclaw_vps_docker_deployment_python_simplified.md` | Python VPS deployment |

## WordPress_Free_Forever/WFF_Edited — Free Hosting Series

| File | Source | Year |
|------|--------|------|
| `wp_free_forever_devbasemedia.md` | DevbaseMedia (5-part series) | 2018-19 |
| `wp_free_forever_gcloud_bitnami_2025_cavementech.md` | CavemenTech | 2025 |
| `free_hosting_docker_2026_tonyteachestech.md` | Tony Teaches Tech (2 videos) | 2025-26 |

## Workflow

1. Find Docker best practices video on YouTube
2. Extract transcript with YouTube Transcript MCP server
3. Save raw transcript to `Docker/` (or `WordPress_Free_Forever/` for hosting content)
4. Run `/clean-transcript` to create cleaned version
5. Move cleaned file to `Docker_Edited/` (or `WFF_Edited/`)

## Prompt Patterns

- **Dockerfile review:** "Review my Dockerfile for security and efficiency"
- **Multi-stage builds:** "Convert this Dockerfile to multi-stage for dev/test/prod"
- **Base image selection:** "What base image for Node.js in production?"
- **Compose setup:** "Docker Compose for local Node.js dev with hot reload"
- **PHP/Drupal stack:** "Set up Docker Compose for Drupal with PHP-FPM, Nginx, MariaDB"
- **Health checks:** "Add health checks for PHP-FPM and MariaDB in Docker Compose"
- **Traefik:** "Configure Traefik reverse proxy for Docker Compose services"
- **Free hosting:** "Set up WordPress on GCP free tier with Docker and SSL"
- **Cloudflare Tunnels:** "Self-host a website with Docker + Cloudflare Tunnels, no port forwarding"
