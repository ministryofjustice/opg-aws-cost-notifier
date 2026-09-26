FROM python:3-bookworm@sha256:bfb689a7986adc6d5f16722e06c78e755efe4062e56276715fef450cbad09436

RUN mkdir /app

WORKDIR /app
COPY requirements.txt requirements.txt
COPY requirements.dev.txt requirements.dev.txt

RUN pip install -Ur requirements.dev.txt
