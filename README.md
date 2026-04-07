# NGINX Load Balancer with FastAPI Backend

This project demonstrates a load-balanced setup with NGINX as a reverse proxy and multiple FastAPI application instances.

## Project Structure

```
.
├── docker-compose.yaml          # Production setup
├── docker-compose-dev.yaml      # Development setup with hot reloading
├── docker-compose-debug.yaml    # Debug setup with profiling tools
├── docker-compose-test.yaml     # Testing setup
├── Makefile                     # Easy command shortcuts
├── nginx.conf                   # NGINX configuration
├── html/                        # Static HTML files
│   └── index.html
└── tobalance/                   # FastAPI application
    ├── dockerfiles/             # All Dockerfiles
    │   ├── Dockerfile           # Production Dockerfile
    │   ├── Dockerfile.alternative
    │   ├── Dockerfile.dev       # Development Dockerfile
    │   ├── Dockerfile.debug     # Debug Dockerfile
    │   └── Dockerfile.test      # Test Dockerfile
    ├── apikeys/                 # API key secrets
    │   ├── api_key1.txt
    │   └── api_key2.txt
    ├── main.py                  # FastAPI application
    ├── requirements.txt         # Python dependencies
    └── tests/                   # Test files
        ├── __init__.py
        └── test_main.py
```

## Quick Start

### Prerequisites
- Docker
- Docker Compose
- Make (optional, but recommended)

### Development Setup

#### Using Make (Recommended)

```bash
# Show all available commands
make help

# Start development environment with hot reloading
make dev

# Build and start development environment
make dev-build

# Stop development environment
make dev-down

# View logs
make logs
```

#### Without Make

```bash
# Start development environment
docker compose -f docker-compose-dev.yaml up

# Build and start
docker compose -f docker-compose-dev.yaml up --build

# Stop
docker compose -f docker-compose-dev.yaml down
```

### Development Features

The development setup includes:
- **Hot Reloading**: Changes to [`main.py`](tobalance/main.py:1) are automatically detected and the server reloads
- **Bind Mounts**: Source code is mounted into containers, no rebuild needed for code changes
- **Fast Iteration**: Edit code and see changes immediately without rebuilding images

### Debugging Setup

For debugging with profiling tools:

```bash
# Start debug environment
make debug

# Or without Make
docker compose -f docker-compose-debug.yaml up --build
```

#### Debug Features

- **Remote Debugging**: debugpy enabled on ports 5678 (app1) and 5679 (app2)
- **Profiling Tools**: py-spy, memory-profiler, line-profiler included
- **Hot Reloading**: Code changes are still reflected without rebuild

#### Connecting VSCode Debugger

Add this to your `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Python: Remote Attach App1",
      "type": "debugpy",
      "request": "attach",
      "connect": {
        "host": "localhost",
        "port": 5678
      },
      "pathMappings": [
        {
          "localRoot": "${workspaceFolder}/tobalance",
          "remoteRoot": "/app"
        }
      ]
    },
    {
      "name": "Python: Remote Attach App2",
      "type": "debugpy",
      "request": "attach",
      "connect": {
        "host": "localhost",
        "port": 5679
      },
      "pathMappings": [
        {
          "localRoot": "${workspaceFolder}/tobalance",
          "remoteRoot": "/app"
        }
      ]
    }
  ]
}
```

#### Using Profiling Tools

```bash
# Profile CPU usage with py-spy
docker exec -it app1-debug py-spy top --pid 1

# Memory profiling
docker exec -it app1-debug python -m memory_profiler main.py
```

### Testing

Run tests in containers:

```bash
# Run tests
make test

# Build and run tests
make test-build

# Or without Make
docker compose -f docker-compose-test.yaml up --build --abort-on-container-exit
```

Tests include:
- Health check endpoint validation
- About endpoint functionality
- Invalid endpoint handling
- Code coverage reporting

### Production Setup

```bash
# Start production environment
make prod

# Build and start
make prod-build

# Or without Make
docker compose -f docker-compose.yaml up --build
```

## Accessing the Application

Once running, access:
- **NGINX Frontend**: http://localhost:8080
- **NGINX HTTPS**: https://localhost:8443
- **Health Check**: http://localhost:8080/ (load balanced between app1 and app2)
- **About Endpoint**: http://localhost:8080/about (load balanced between app1 and app2)

## Development Workflow

1. **Start Development Environment**
   ```bash
   make dev-build
   ```

2. **Make Code Changes**
   - Edit [`tobalance/main.py`](tobalance/main.py:1)
   - Changes are automatically detected and server reloads
   - No rebuild required

3. **Run Tests**
   ```bash
   make test
   ```

4. **Debug Issues**
   ```bash
   make debug
   # Connect VSCode debugger to port 5678 or 5679
   ```

5. **Clean Up**
   ```bash
   make clean
   ```

## Architecture

- **NGINX**: Acts as a reverse proxy and load balancer
- **app1 & app2**: Two FastAPI instances for load balancing
- **Secrets**: API keys mounted securely via Docker secrets
- **Health Checks**: Automatic health monitoring with restart on failure

## Tips

- Use `make help` to see all available commands
- Development mode uses bind mounts for instant code updates
- Debug mode includes profiling tools for performance analysis
- Test mode runs with coverage reporting
- All environments use the same secrets for consistency
