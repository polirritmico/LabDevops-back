# 🖥 LabDevops Backend

This is the backend of the full project.

The front could be found here: https://github.com/polirritmico/LabDevops-front.

The back and front DockerHub images could be found here:
https://hub.docker.com/repository/docker/polirritmico/labdevops-back
https://hub.docker.com/repository/docker/polirritmico/labdevops-front

## Setup

### ENV and secrets settings for the pipeline

On the GitHub repository settings add:

**Secrets:**

```
DOCKERHUB_TOKEN
SNYK_TOKEN
SONAR_TOKEN
```

The values of these secret variables should have been included along with the
project delivery.

**Variables:**

```
COVERAGE_THRESHOLD   70
DOCKERHUB_IMAGE      labdevops-back
DOCKERHUB_USERNAME   polirritmico
```

## Local Usage

Since by itself the backend doesn't do much, the project execution instructions
are in the Frontend repository
[README](https://github.com/polirritmico/LabDevops-front/blob/main/README.md). A
`docker-compose.yml` is provided that uses the built backend and frontend Docker
images directly from Docker Hub.

---

## 🏭 CI/CD Pipeline - Traceability and Quality Assurance

This project implements a two-stage CI/CD pipeline designed to ensure code
quality, security and adheres to high level standards. The GitHub workflows
allows an easy actions-driven setup that helps us to achieve this and keep a
full traceability of the process to each commit that arrives into the selected
branches.

Here is a step-by-step description:

### 🔎 Stage 1. Validations

After a push to `main` or `develop` is detected, triggers this sequence of jobs:

1. **Ruff Linter:** A standard modern static python code analyser to check rules
   and style conventions.
2. **Black Formatter:** Validates the code formatting compliance according to
   the project style. This enforce clean commit diffs and avoids clutter logs.
3. **Tests and Coverage:** Execute all tests (unit, acceptance, integration,
   etc.) through `pytest` generating coverage reports. The pipeline execution
   fails if the reported coverage drops below $70%$ enforcing good testing
   practices.
4. **Snyk Security Scan:** Reports vulnerabilities in dependencies. High or
   critical issues cause a failure to prevent insecure code merges.
5. **SonarQube Analysis:** Runs static code analysis to detect code smells,
   bugs, and maintainability issues.

In general, this validations establish a **high quality threshold** since only
by passing all the checks the image is built and uploaded to the DockerHub.

This stage produce artifacts that are uploaded for future traceability and
audits.

#### 📝 Some notes

Since Snyk does not support **uv**, a workaround is used to export the packages
into a `requirements.txt` and use that through **pip** so Snyk can access all
dependencies:

```bash
uv export --format=requirements.txt > requirements.txt
```

Fortunately, support for **uv** is planned by the Snyk team:
https://github.com/snyk/snyk-python-plugin/issues/251#issuecomment-3431929229.
In the future, this workaround will no longer be needed.

### 📦 Stage 2. Deployment

Triggered automatically after successful validation of stage 1 (only on `main`
branch). This is the jobs sequence:

1. **Docker Image Build:** Builds both `amd64` and `arm64` images using a
   reproducible environment (`target: production`) and tags them with `latest`
   and the commit SHA.
2. **Snyk Container Scan:** Checks the resulting image for vulnerabilities. Any
   high or critical problem blocks the image publication.
3. **Docker push:** Only if all other checks and validations pass, the image is
   finally pushed into the DockerHub, ensuring that each published image adheres
   to a verified commit.

Together, all these mechanisms ensure the backend meets high standards of
reliability, maintainability and security on every deployed image. The registry
and artifacts (tied with specifics commits SHAs) provide a fully auditable and
verifiable result.

## Project directory structure

The project has the following directories structure:

```
LabDevops-back
├── coverage.xml
├── docker-compose.yml
├── Dockerfile
├── pyproject.toml
├── README.md
├── src
│   └── main.py
├── tests
│   └── acceptance_test.py
└── uv.lock
```
