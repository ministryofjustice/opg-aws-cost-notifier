FROM python:3.15-bookworm@sha256:2734c1683bd937b316f31b18972026302f155f0ffd932b329811d2e3a8450775

RUN mkdir /app

WORKDIR /app
COPY requirements.txt requirements.txt
COPY requirements.dev.txt requirements.dev.txt

RUN pip install -Ur requirements.dev.txt
