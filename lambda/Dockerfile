# Define function directory
ARG FUNCTION_DIR="/function"

FROM python:alpine3.16 AS python-alpine
RUN apk add --no-cache \
    libstdc++

RUN python -m pip install --upgrade pip

FROM python-alpine as build-image

# Install aws-lambda-cpp build dependencies
RUN apk add --no-cache \
    build-base \
    libtool \
    autoconf \
    automake \
    libexecinfo-dev \
    make \
    cmake \
    libcurl

# Include global arg in this stage of the build
ARG FUNCTION_DIR
# Create function directory
RUN mkdir -p ${FUNCTION_DIR}

# Copy function code
COPY function/send_cost_anomalies_to_slack.py ${FUNCTION_DIR}/send_cost_anomalies_to_slack.py

COPY requirements.txt requirements.txt

# Install the runtime interface client
RUN python -m pip install \
    --target ${FUNCTION_DIR} \
    --requirement requirements.txt

# Multi-stage build: grab a fresh copy of the base image
FROM python-alpine AS production

# Patch security vulnerabilities
RUN apk upgrade --no-cache libcrypto1.1 libssl1.1 ncurses-terminfo-base sqlite-libs

# Include global arg in this stage of the build
ARG FUNCTION_DIR
# Set working directory to function root directory
WORKDIR ${FUNCTION_DIR}

# Copy in the build image dependencies
COPY --from=build-image ${FUNCTION_DIR} ${FUNCTION_DIR}

ENTRYPOINT [ "/usr/local/bin/python", "-m", "awslambdaric" ]
CMD [ "send_cost_anomalies_to_slack.lambda_handler" ]
