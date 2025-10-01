# Define function directory
ARG FUNCTION_DIR="/function"

FROM python:alpine AS python-alpine
RUN apk -U --no-cache upgrade && \
    apk add --no-cache \
    libstdc++ \
    zstd-libs

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

COPY requirements.txt requirements.txt

# Install the runtime interface client
RUN python -m pip install --upgrade pip
RUN python -m pip install \
    --target ${FUNCTION_DIR} \
    --requirement requirements.txt

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
