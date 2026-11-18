# Define function directory
ARG FUNCTION_DIR="/function"

FROM ghcr.io/astral-sh/uv:0.13.5@sha256:32a7bb39b496babbd997b0a39a4d66c126bdaf5661b302bf6f06abda8deca6ff AS uv

FROM python:3.15-alpine@sha256:d44b1254cb92329418d164b22b20d86bbd3869d48e80e09e476531a409a728bb AS python-alpine
RUN apk -U --no-cache upgrade && \
    apk add --no-cache \
    libstdc++ \
    zstd-libs
# Upgrade Pip
RUN python -m pip install --upgrade pip

FROM python-alpine AS build-image

# Install aws-lambda-cpp build dependencies
RUN apk add --no-cache \
    autoconf \
    automake \
    build-base \
    cmake \
    elfutils-dev \
    libcurl \
    libtool \
    make

# Include global arg in this stage of the build
ARG FUNCTION_DIR
# Create function directory
RUN mkdir -p ${FUNCTION_DIR}

# Copy function code
COPY function/send_cost_anomalies_to_slack.py ${FUNCTION_DIR}/send_cost_anomalies_to_slack.py

# Install locked, hash-verified dependencies (including the runtime interface client)
RUN --mount=from=uv,source=/uv,target=/bin/uv \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    uv export --frozen --no-dev --no-emit-project --format requirements-txt --output-file /tmp/requirements.txt && \
    uv pip install \
    --system \
    --no-cache \
    --require-hashes \
    --target ${FUNCTION_DIR} \
    --requirement /tmp/requirements.txt

# Multi-stage build: grab a fresh copy of the base image
FROM python-alpine AS production

# Patch security vulnerabilities
RUN apk upgrade --no-cache libcrypto3 libssl3

# Include global arg in this stage of the build
ARG FUNCTION_DIR
# Set working directory to function root directory
WORKDIR ${FUNCTION_DIR}
# Switch to Non-Root User
USER 1001
# Copy in the build image dependencies
COPY --from=build-image ${FUNCTION_DIR} ${FUNCTION_DIR}

ENTRYPOINT [ "/usr/local/bin/python", "-m", "awslambdaric" ]
CMD [ "send_cost_anomalies_to_slack.lambda_handler" ]
