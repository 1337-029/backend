# Leet chat backend

# Requirements

1. docker + docker-compose
2. python-poetry (`pip install poetry`)

# Start

To start containers run

```bash
make up
# or
docker-compose up --build # --build to rebuild images
```

Restart container with

```bash
make r-web # restart backend
make r-db # restart db
```

# Develop

Initialize dev environment with

```bash
make dev
```