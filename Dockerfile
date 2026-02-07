# Stage 1: Build
FROM python:3.12-slim-bookworm AS builder

# Set environment variables for Poetry 2.0
ENV POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_VIRTUALENVS_CREATE=1 \
    POETRY_CACHE_DIR=/tmp/poetry_cache

# Install git (required to pull your mqtt-connector-lib from GitHub)
# IMPORTANT: Added build-essential and python3-dev here for compiling C extensions (psutil, etc.)
RUN apt-get update && \
    apt-get install -y git build-essential python3-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Poetry 2.0
RUN pip install poetry

# Copy ONLY dependency files first (standard Docker optimization)
COPY pyproject.toml poetry.lock README.md ./

# Install dependencies without the project source code
# This will now succeed because gcc is available to build psutil
RUN --mount=type=cache,target=$POETRY_CACHE_DIR poetry install --no-root --all-extras

# Stage 2: Runtime
FROM python:3.12-slim-bookworm AS runtime

# Set runtime env
ENV PATH="/app/.venv/bin:$PATH" \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Copy the pre-built virtual environment from builder
# We only copy the final compiled result, so the final image stays small
COPY --from=builder /app/.venv /app/.venv

# Copy your actual source code
COPY src ./src
COPY config.json ./

# Run the project using module syntax (enables absolute imports)
ENTRYPOINT ["python", "-m", "rebalancing_bot"]
