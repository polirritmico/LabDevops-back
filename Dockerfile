FROM python:3.13-slim AS base
LABEL maintainer="Eduardo Bray <ed.bray@duocuc.cl>"

ARG USER=devops

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
    && useradd -m "$USER" \
    && install -d -o "$USER" -g "$USER" /app \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
USER $USER:$USER
ENV PATH="/home/$USER/.local/bin:$PATH"
RUN pip install --no-cache-dir uv
COPY --chown=$USER:$USER pyproject.toml uv.lock ./


FROM base AS develop
RUN uv sync --frozen --dev
EXPOSE 8080
CMD ["uv", "run", "fastapi", "dev", "src/main.py", "--host", "0.0.0.0", "--port", "8080"]


FROM base AS production
ENV PYTHONDONTWRITEBYTECODE=true \
    PYTHONUNBUFFERED=true
RUN uv sync --frozen
COPY --chown=$USER:$USER . .
EXPOSE 8080
CMD ["uv", "run", "fastapi", "run", "--host", "0.0.0.0", "--port", "8080", "src/main.py"]
