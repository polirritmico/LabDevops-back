FROM python:3.13-slim AS base
LABEL maintainer="Eduardo Bray <ed.bray@duocuc.cl>"

ARG USER=devops

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
    && useradd -m $USER \
    && install -d -o $USER -g $USER /app \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
USER $USER:$USER
ENV PATH="/home/$USER/.local/bin:$PATH"
COPY --chown=$USER:$USER requirements*.txt .
RUN pip install --no-cache-dir --upgrade --user -r requirements.txt


FROM base AS develop
RUN pip install --no-cache-dir --user -r requirements-dev.txt
EXPOSE 8080
CMD ["fastapi", "dev", "src/main.py", "--host", "0.0.0.0", "--port", "8080"]


FROM base AS production
ENV PYTHONDONTWRITEBYTECODE=true
ENV PYTHONUNBUFFERED=true
EXPOSE 8080
CMD ["fastapi", "run", "--host", "0.0.0.0", "--port", "8080"]
