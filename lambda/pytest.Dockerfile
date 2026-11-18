FROM ghcr.io/astral-sh/uv:0.13.5@sha256:32a7bb39b496babbd997b0a39a4d66c126bdaf5661b302bf6f06abda8deca6ff AS uv

FROM python:3.15-bookworm@sha256:2734c1683bd937b316f31b18972026302f155f0ffd932b329811d2e3a8450775

RUN mkdir /app

WORKDIR /app

COPY pyproject.toml uv.lock ./

ENV PATH="/app/.venv/bin:$PATH"

RUN --mount=from=uv,source=/uv,target=/bin/uv \
    uv sync --frozen
