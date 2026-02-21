# Docker — CLAUDE.md

## Purpose

Docker and DevOps best practices transcripts, primarily from Bret Fisher's talks and Node.js Docker content.

## Structure

```
Docker/
├── *.txt                  # Raw transcripts
└── Docker_Edited/         # Cleaned transcripts + system prompt
    └── DOCKER_SYSTEM_PROMPT.md
```

## Key Files

- `Docker_Edited/DOCKER_SYSTEM_PROMPT.md` — System prompt for Docker best practices project

## Cleaned Transcripts

| File | Source |
|------|--------|
| `docker_production_best_practices_dockercon2017.md` | Bret Fisher, DockerCon 2017 |
| `docktalk_nodejs_best_practices_2020.md` | Bret Fisher, 2020 |
| `late_night_docker_ama_nodejs_2018.md` | Bret Fisher AMA, 2018 |
| `nodejs_rocks_in_docker_dockercon2022.md` | Bret Fisher, DockerCon 2022 |
| `nodejs_rocks_in_docker_dockercon2023.md` | Bret Fisher, DockerCon 2023 |
| `buildkit_advanced_features_reference.md` | BuildKit reference |
| `nextjs_docker_best_practices_2025.md` | Next.js Docker guide |

## Workflow

1. Find Docker best practices video on YouTube
2. Extract transcript with YouTube Transcript MCP server
3. Save raw transcript to `Docker/`
4. Run `/clean-transcript` to create cleaned version
5. Move cleaned file to `Docker_Edited/`

## Prompt Patterns

- **Dockerfile review:** "Review my Dockerfile for security and efficiency"
- **Multi-stage builds:** "Convert this Dockerfile to multi-stage for dev/test/prod"
- **Base image selection:** "What base image for Node.js in production?"
- **Compose setup:** "Docker Compose for local Node.js dev with hot reload"
